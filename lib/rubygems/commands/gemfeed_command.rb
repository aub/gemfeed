require 'rubygems/command'

class Gem::Commands::GemfeedCommand < Gem::Command

  def initialize
    super 'gemfeed', 'Export subscribed gems to your gemfeed account'
  end

  def execute
    # RubygemsAnalyzer.new.run options[:args]
    say "Bad fuckin' ass"
  end

end

