require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "gemfeed"
    gem.summary = %Q{A gem for managing gemfeed subscriptions}
    gem.description = %Q{This gem provides automatic post install and uninstall hooks to allow you to subscribe to gems with gemfeed. It also provides a command that allows you to automatically install to all gems that are currently installed.}
    gem.email = "aubreyholland@gmail.com"
    gem.homepage = "http://github.com/aub/gemfeed"
    gem.authors = ["Aubrey Holland"]
    gem.add_development_dependency "rspec"
    gem.files = Dir['lib/**/*.rb']
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "gemfeed #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
