require 'gemfeed'
require 'net/http'
require 'rubygems/command_manager'
require 'uri'
require 'rexml/document'

Gem::CommandManager.instance.register_command :gemfeed

Gem.post_install do |installer|
  begin
    unless installer.spec.name == 'gemfeed'
      Gemfeed.subscribe_to_gem(installer.spec.name)
    end
  rescue Exception => e
    # just trying to make absolutely sure that we can't block
    # the gem installation at the moment.
  end
end

Gem.post_uninstall do |uninstaller|
  begin
    unless uninstaller.spec.name == 'gemfeed'
      Gemfeed.unsubscribe_from_gem(uninstaller.spec.name)
    end
  rescue Exception => e
    # just trying to make absolutely sure that we can't block
    # the gem installation at the moment.
  end
end 

