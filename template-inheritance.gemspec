#!/usr/bin/env gem build
# encoding: utf-8

require "base64"

Gem::Specification.new do |s|
  s.name = "template-inheritance"
  s.version = "0.1.3"
  s.authors = ["Jakub Šťastný aka Botanicus"]
  s.homepage = "http://github.com/botanicus/template-inheritance"
  s.summary = ""
  s.description = "" # TODO: long description
  s.cert_chain = nil
  s.email = Base64.decode64("c3Rhc3RueUAxMDFpZGVhcy5jeg==\n")
  s.has_rdoc = true

  # files
  s.files = `git ls-files`.split("\n")

  s.require_paths = ["lib"]

  # Ruby version
  # Current JRuby with --1.9 switch has RUBY_VERSION set to "1.9.2dev"
  # and RubyGems don't play well with it, so we have to set minimal
  # Ruby version to 1.9, even if it actually is 1.9.1
  s.required_ruby_version = ::Gem::Requirement.new("~> 1.9")

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
