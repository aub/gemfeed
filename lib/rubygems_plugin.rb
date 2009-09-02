require 'net/http'
require 'rubygems/command_manager'
require 'uri'
require 'rexml/document'

require 'ruby-debug'

Gem::CommandManager.instance.register_command :gemfeed

module Gemfeed
  def self.check_gemfeed_login
    unless Gem.configuration['gemfeed_login']
      puts '!!! You gemfeed login is not configured correctly. Please add a line like:'
      puts '!!! gemfeed_login: aubreyholland@gmail.com'
      puts '!!! to your ~/.gemrc file. If you have a password with gemfeed, you should also add a line like:'
      puts '!!! gemfeed_password: super_secret'
      nil
    end
    return true
  end

  def self.print_unauthorized_error
    puts '!!! Unable to log in to gemfeed with the given login and password. Check your'
    puts '!!! ~/.gemrc file and make sure that gemfeed_login and gemfeed_password are'
    puts '!!! configured correctly, like:'
    puts '!!! gemfeed_login: aubreyholland@gmail.com'
    puts '!!! gemfeed_password: super_secret'
  end

  def self.prepare_request(type, url)
    case type
    when :post then req = Net::HTTP::Post.new(url.path)
    when :get then req = Net::HTTP::Get.new(url.path)
    when :delete then req = Net::HTTP::Delete.new(url.path)
    when :put then req = Net::HTTP::Put.new(url.path)
    end
    req.basic_auth Gem.configuration['gemfeed_login'], Gem.configuration['gemfeed_password']
    req['Content-Type'] = 'text/xml'
    req
  end

  def self.make_request(url, req, &block)
    res = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
    case res
    when Net::HTTPSuccess
      block.call
    when Net::HTTPUnauthorized:
      Gemfeed.print_unauthorized_error
    when Net::HTTPClientError:
      doc = REXML::Document.new(res.body)
      doc.elements.each('errors/error') do |error| 
        if error.text == 'User has already been taken'
          puts "!!! You are already subscribed to #{installer.spec.name} on gemfeed."
        elsif error.text == 'Package can\'t be blank'
          puts "!!! Gemfeed cannot find the gem #{installer.spec.name}"
        end
      end
    end
  end

  def self.get_subscription_url(name)
    url = URI.parse('http://localhost:3000/subscriptions.xml')
    req = prepare_request(:get, url)

    Gemfeed.make_request(url, req) do |body|
      debugger
      nil
    end
  end
end

Gem.post_install do |installer|
  begin
    unless installer.spec.name == 'gemfeed'
      unless Gemfeed.check_gemfeed_login
        return
      end

      url = URI.parse('http://localhost:3000/subscriptions.xml')
      req = prepare_request(:post, url)
      req.body = "<package name=\"#{installer.spec.name}\"/>"

      Gemfeed.make_request(url, req) do |body|
        puts "!!! Gemfeed has subscribed you to #{installer.spec.name}"
      end
    end
  rescue Exception => e
    # just trying to make absolutely sure that we can't block
    # the gem installation at the moment.
  end
end

Gem.post_uninstall do |uninstaller|
  debugger
  begin
    unless uninstaller.spec.name == 'gemfeed'
      unless Gemfeed.check_gemfeed_login
        return
      end

      url = URI.parse(Gemfeed.get_subscription_url(uninstaller.spec.name))
      req = prepare_request(:delete, url)

      Gemfeed.make_request(url, req) do |body|
        puts "!!! Gemfeed has unsubscribed you from #{uninstaller.spec.name}"
      end
    end
  rescue Exception => e
    0
    # just trying to make absolutely sure that we can't block
    # the gem installation at the moment.
  end
end 

