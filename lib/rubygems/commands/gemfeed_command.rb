require 'rubygems/command'
require 'gemfeed'

class Gem::Commands::GemfeedCommand < Gem::Command

  def initialize
    super 'gemfeed', 'Export subscribed gems to your gemfeed account'
  end

  def execute
    begin
      Gemfeed.check_gemfeed_login
      gem_names = Gem.source_index.gems.collect { |k,v| v.name }.uniq.sort
      say "Subscribing you to #{gem_names.size} gems on gemfeed..."
      gem_names.each do |name|
        say "Subscribing to #{name}"
        Gemfeed.subscribe_to_gem(name)
      end
    rescue
      exit()
    end
  end
end

