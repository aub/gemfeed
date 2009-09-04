module Gemfeed

  GEMFEED_URL = 'http://gemfeed.com'

  class GemfeedLoginError < StandardError; end;

  def self.subscribe_to_gem(gem_name)
    check_gemfeed_login
    url = URI.join(GEMFEED_URL, 'subscriptions.xml')
    req = prepare_request(:post, url)
    req.body = "<package name=\"#{gem_name}\"/>"

    make_request(url, req, gem_name) do |body|
      puts "!!! Gemfeed has subscribed you to #{gem_name}"
    end
  end

  def self.unsubscribe_from_gem(gem_name)
    check_gemfeed_login
    url = URI.join(GEMFEED_URL, get_subscription_url(gem_name))
    req = prepare_request(:delete, url)

    make_request(url, req, gem_name) do |body|
      puts "!!! Gemfeed has unsubscribed you from #{gem_name}"
    end
  end

  def self.check_gemfeed_login
    unless Gem.configuration['gemfeed_login']
      puts '!!! You gemfeed login is not configured correctly. Please add a line like:'
      puts '!!! gemfeed_login: aubreyholland@gmail.com'
      puts '!!! to your ~/.gemrc file. If you have a password with gemfeed, you should also add a line like:'
      puts '!!! gemfeed_password: super_secret'
      puts '!!! If you just want to stop receiving this message, remove the gemfeed gem:'
      puts '!!! gem uninstall gemfeed'
      raise GemfeedLoginError.new
    end
  end

  def self.print_unauthorized_error
    puts '!!! Unable to log in to gemfeed with the given login and password. Check your'
    puts '!!! ~/.gemrc file and make sure that gemfeed_login and gemfeed_password are'
    puts '!!! configured correctly, like:'
    puts '!!! gemfeed_login: aubreyholland@gmail.com'
    puts '!!! gemfeed_password: super_secret'
    puts '!!! If you just want to stop receiving this message, remove the gemfeed gem:'
    puts '!!! gem uninstall gemfeed'
    raise GemfeedLoginError.new
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

  def self.make_request(url, req, gem_name, &block)
    begin
      res = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
      case res
      when Net::HTTPSuccess
        block.call(res.body)
      when Net::HTTPUnauthorized:
        print_unauthorized_error
      when Net::HTTPClientError:
        doc = REXML::Document.new(res.body)
        doc.elements.each('errors/error') do |error| 
          if error.text == 'User has already been taken'
            puts "!!! You are already subscribed to #{gem_name} on gemfeed."
          elsif error.text == 'Package can\'t be blank'
            puts "!!! Gemfeed cannot find the gem #{gem_name}"
          end
        end
      else
        puts '!!! There was a server error while subscribing you to this gem on gemfeed.'
      end
    rescue Errno::ECONNREFUSED
      puts '!!! There was an error when connecting to the server.'
    end
  end

  def self.get_subscription_url(name)
    url = URI.join(GEMFEED_URL, 'subscriptions.xml')
    req = prepare_request(:get, url)

    make_request(url, req, name) do |body|
      doc = REXML::Document.new(body)
      doc.elements.each('subscriptions/subscription') do |subscription| 
        return subscription.elements['path'].text if subscription.elements['package/name'] 
      end
    end
  end
end
