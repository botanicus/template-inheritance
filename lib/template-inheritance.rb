# encoding: utf-8

require "template-inheritance/exts/tilt"
require "template-inheritance/helpers"

module TemplateInheritance
  @@development = true
  def self.development=(boolean)
    @@development = boolean
  end

  def self.development?
    @@development
  end

  def self.logger
    @@logger ||= SimpleLogger.new
  end

  def self.logger=(logger)
    @@logger = logger
  end

  class TemplateNotFound < StandardError
    def initialize(relative_path)
      super("Template #{relative_path} not found in #{Template.paths.inspect}")
    end
  end

  class SimpleLogger
    def log(message)
      puts "~ #{message}"
    end

    alias_method :info, :log
    alias_method :debug, :log
  end

  class Template
    def self.paths
      @@paths ||= Array.new
    end

    # template -> supertemplate is the same relationship as class -> superclass
    # @since 0.0.2
    attr_accessor :path, :scope, :supertemplate, :context

    # @since 0.0.2
    attr_writer :blocks
    def blocks
      @blocks ||= Hash.new
    end

    # @since 0.0.2
    def initialize(path, scope = Object.new)
      self.path  = path#[scope.class.template_prefix.chomp("/"), template].join("/")
      self.scope = scope
      self.scope.extend(TemplateHelpers)
      # this enables template caching
      unless TemplateInheritance.development?
        self.scope.extend(Tilt::CompileSite)
      end
      self.scope.template = self
    end

    # @since 0.0.2
    def fullpath
      @fullpath ||= begin
        if self.path.match(/^(\/|\.)/) # /foo or ./foo
          find_file(self.path, "#{self.path}.*")
        else
          self.find_in_paths
        end
      end
    end

    def adapter
      snake_case(self.template.class.name.split("::").last).sub("_template", "")
    end

    def extension # haml, erb ...
      File.extname(path)[1..-1]
    end

    def template(options = Hash.new)
      @template ||= Tilt.new(self.fullpath, nil, options)
    end

    # @since 0.0.2
    def render(context = Hash.new)
      raise TemplateNotFound.new("Template #{self.path} wasn't found in these paths: #{self.class.paths.inspect}") if self.fullpath.nil?
      TemplateInheritance.logger.info("Rendering template #{self.path} with context keys #{context.keys.inspect}")
      self.scope.context = self.context = context # so we can access context in the scope object as well
      value = self.template.render(self.scope, context)
      TemplateInheritance.logger.debug("Available blocks: #{self.blocks.keys.inspect}")
      if self.supertemplate
        TemplateInheritance.logger.debug("Extends call: #{self.supertemplate}")
        supertemplate = self.class.new(self.supertemplate, self.scope)
        supertemplate.blocks = self.blocks
        return supertemplate.render(context)
      end
      value
    end

    protected
    def find_in_paths
      self.class.paths.inject(nil) do |real, directory|
        if real.nil?
          path = File.join(directory, self.path)
          find_file(path, "#{path}.*")
        else
          real
        end
      end
    end

    def find_file(one, other)
      alternatives = Dir[one, other]
      alternatives.find { |file| File.file?(file) }
    end

    def snake_case(string)
      return string.downcase if string =~ /^[A-Z]+$/
      string.gsub(/([A-Z]+)(?=[A-Z][a-z]?)|\B[A-Z]/, '_\&') =~ /_*(.*)/
        return $+.downcase
    end
  end
end
