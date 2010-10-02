# encoding: utf-8

$LOAD_PATH << File.expand_path("../../lib", __FILE__)

require "ostruct"
require "template-inheritance"

TemplateInheritance::Template.paths << File.expand_path("..", __FILE__)

post = OpenStruct.new(title: "My First Post!", content: "This is my first post!")

# setup
Tilt::HamlTemplate.options[:default_attributes] = {form: {method: "post"}}

template = TemplateInheritance::Template.new("site/post.html.haml")
puts "", template.render(post: post)
