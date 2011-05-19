# encoding: utf-8

require "template-inheritance"
require "padrino-core/application/rendering"

# TODO: It'd be nice to share the logger.
module TemplateInheritance
  class Template
    attr_accessor :padrino_views_directory
  end

  module TemplateHelpers
    alias_method :_normalize_template_path, :normalize_template_path
    def normalize_template_path(path)
      full_path = File.join(template.padrino_views_directory, path)
      _normalize_template_path(full_path)
    end
  end
end

module TemplateInheritance::Rendering
  def self.registered(app)
    app.helpers(self)
    app.register(Padrino::Rendering)
  end

  # TODO: support options for Haml.
  # NOTE: block does nothing.
  # FIXME: locals doesn't work because we don't get them from Padrino.
  include Module.new {
    def render(_, path, options, locals, &block)
      base_dir = options[:views] || settings.views || "./views"
      fullpath = File.join(base_dir, path.to_s)
      template = TemplateInheritance::Template.new(fullpath, self)
      template.padrino_views_directory = base_dir
      options && options.delete(:layout_engine)
      options && options.delete(:layout)
      template.render(locals)
    end
  }
end
