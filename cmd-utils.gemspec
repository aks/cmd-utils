# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: cmd-utils 1.1.2 ruby lib

Gem::Specification.new do |s|
  s.name = "cmd-utils"
  s.version = "1.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Alan K. Stebbens"]
  s.date = "2014-03-03"
  s.description = "Several ruby libraries for building command-line utilities."
  s.email = "aks@stebbens.org"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "cmd-utils.gemspec",
    "lib/cmd-utils.rb",
    "lib/lookup.rb",
    "lib/ssh-utils.rb",
    "test/helper.rb",
    "test/test-cmd-utils.rb",
    "test/test-lookup.rb",
    "test/test_cmd-utils.rb.off"
  ]
  s.homepage = "http://bitbucket.org/aks_/cmd-utils"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Utilities for building CLIs"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<minitest>, [">= 5.3.0"])
      s.add_development_dependency(%q<rdoc>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
    else
      s.add_dependency(%q<minitest>, [">= 5.3.0"])
      s.add_dependency(%q<rdoc>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
  else
    s.add_dependency(%q<minitest>, [">= 5.3.0"])
    s.add_dependency(%q<rdoc>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
  end
end
