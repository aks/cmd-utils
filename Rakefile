# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "cmd-utils"
  gem.homepage = "http://github.com/aks/cmd-utils"
  gem.license = "MIT"
  gem.summary = %Q{Utilities for building CLIs}
  gem.description = %Q{Several ruby libraries for building command-line utilities.}
  gem.email = "aks@stebbens.org"
  gem.authors = ["Alan K. Stebbens"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test-*.rb'
  test.verbose = true
end

#desc "Code coverage detail"
#task :simplecov do
#  ENV['COVERAGE'] = "true"
#  Rake::Task['test'].execute
#end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "cmd-utils #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
