#!/usr/bin/env gem build
# encoding: utf-8

require "base64"

Gem::Specification.new do |s|
  s.name = "template-inheritance"
  s.version = "0.3.1"
  s.authors = ["Jakub Šťastný aka Botanicus"]
  s.homepage = "http://github.com/botanicus/template-inheritance"
  s.summary = ""
  s.description = "" # TODO: long description
  s.email = Base64.decode64("c3Rhc3RueUAxMDFpZGVhcy5jeg==\n")
  s.has_rdoc = true

  # files
  s.files = `git ls-files`.split("\n")

  s.require_paths = ["lib"]

  # dependencies
  s.add_dependency "tilt"
  s.add_dependency "haml"

  # begin
  #   require "changelog"
  # rescue LoadError
  #   warn "You have to have changelog gem installed for post install message"
  # else
  #   s.post_install_message = CHANGELOG.new.version_changes
  # end

  # RubyForge
  s.rubyforge_project = "template-inheritance"
end
