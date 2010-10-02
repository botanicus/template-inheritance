# encoding: utf-8

require "tilt"

module TemplateInheritance
  module TiltExtensions
    # Tilt::HamlTemplate.options[:default_attributes] = {script: {type: "text/javascript"}, form: {method: "POST"}}
    module Haml
      def self.included(klass)
        klass.send(:remove_method, :initialize_engine)
        def klass.options
          @options ||= Hash.new
        end
      end

      def initialize_engine
        require_template_library 'haml' unless defined? ::Haml::Engine
        require "template-inheritance/exts/haml" if self.class.options[:default_attributes]
      end

      def initialize(*args)
        super
        self.options.merge!(self.class.options)
      end
    end
  end
end

Tilt::HamlTemplate.send(:include, TemplateInheritance::TiltExtensions::Haml)
