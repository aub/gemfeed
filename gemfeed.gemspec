# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gemfeed}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aubrey Holland"]
  s.date = %q{2009-09-04}
  s.description = %q{This gem provides automatic post install and uninstall hooks to allow you to subscribe to gems with gemfeed. It also provides a command that allows you to automatically install to all gems that are currently installed.}
  s.email = %q{aubreyholland@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    "lib/gemfeed.rb",
     "lib/rubygems/commands/gemfeed_command.rb",
     "lib/rubygems_plugin.rb"
  ]
  s.homepage = %q{http://github.com/aub/gemfeed}
  s.post_install_message = %q{**************************************************

  The gemfeed gem is now installed. You need to configure it by
  editing your ~/.gemrc file and adding lines like:

  gemfeed_login: {your gemfeed login}
  gemfeed_password: {your gemfeed password, if you have one}

  Now, you can use "gem gemfeed" to subscribe to all existing gems, and
  subscriptions will automatically be created and removed as gems are
  installed and removed.

**************************************************
}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{A gem for managing gemfeed subscriptions}
  s.test_files = [
    "spec/gemfeed_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
