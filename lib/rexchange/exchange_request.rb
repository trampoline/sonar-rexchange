require 'net/https'

module RExchange

  # Exchange Server's WebDAV interface is non-standard, so
  # we create this simple wrapper to extend the 'net/http'
  # library and add the request methods we need.
  class ExchangeRequest < Net::HTTPRequest
    REQUEST_HAS_BODY = true
    RESPONSE_HAS_BODY = true

    def self.authenticate(credentials)
      owa_uri = credentials.owa_uri
      if owa_uri
        http = Net::HTTP.new(owa_uri.host, owa_uri.port)
        http.set_debug_output(RExchange::DEBUG_STREAM) if RExchange::DEBUG_STREAM
        req = Net::HTTP::Post.new(owa_uri.path)
        destination = owa_uri.scheme+"://"+owa_uri.host+(owa_uri.port ? ':'+owa_uri.port.to_s : '')
        req.body = "destination=#{destination}&username=#{credentials.user}&password=#{credentials.password}"
        http.use_ssl = owa_uri.scheme ? (owa_uri.scheme.downcase == 'https') : false
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        res = http.request(req)
        credentials.auth_cookie = res.header["set-cookie"].split(',').map(&:strip).map{|c| c.split(';')[0]}.reverse.join('; ') if res.header["set-cookie"]
      end
    end

    def self.exchange_request(credentials, options = {})
      http = Net::HTTP.new(credentials.dav_uri.host, credentials.dav_uri.port)
      http.set_debug_output(RExchange::DEBUG_STREAM) if RExchange::DEBUG_STREAM
      request_path = options[:path] || credentials.dav_uri.path
      req = self.new(request_path)
      options[:request] = req
      req.basic_auth credentials.user, credentials.password #if !credentials.is_owa?
      req.content_type = 'text/xml'
      req.add_field 'host', credentials.dav_uri.host

      if options[:headers]
        options[:headers].each_pair do |k, v|
          req.add_field k, v
        end
      end

      req.body = options[:body] if REQUEST_HAS_BODY
      http.use_ssl = credentials.dav_use_ssl?
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.request(req) if RESPONSE_HAS_BODY

    end

    def self.execute(credentials, options = {}, &b)
      begin
        headers = options[:headers] ||= {}
        headers['Cookie'] = credentials.auth_cookie if credentials.auth_cookie
        response = self.exchange_request(credentials, options)
        case response
        when Net::HTTPClientError then
          self.authenticate(credentials)
          #repeat exchange_request after authentication with the auth-cookies
          headers = options[:headers] ||= {}
          headers['Cookie'] = credentials.auth_cookie if credentials.auth_cookie
          response = self.exchange_request(credentials, options)
        end

        raise 'NOT 2xx NOR 3xx: ' + response.inspect.to_s unless (Net::HTTPSuccess === response || Net::HTTPRedirection === response)
        
        yield response if b
        response
      rescue RException => e
        raise e
      rescue Exception => e
        #puts e.backtrace.map{|e| e.to_s}.join("\n")
        raise RException.new(options[:request], response, e)
      end

    end

    private
    # You can not instantiate an ExchangeRequest externally.
    def initialize(*args)
      super
    end
  end
end



