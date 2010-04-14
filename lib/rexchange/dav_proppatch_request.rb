require 'rexchange/exchange_request'

module RExchange
  # Used to move entities to different locations in the accessable mailbox.
  class DavProppatchRequest < ExchangeRequest
    METHOD = 'PROPPATCH'


    def self.request_body(property, name_space, value)
      <<-eos
    <D:propertyupdate xmlns:D = "DAV:">
       <D:set>
          <D:prop>
            <X:#{property} xmlns:X = "#{name_space}:">#{value}</X:read>
          </D:prop>
       </D:set>
    </D:propertyupdate>
      eos
    end

    def self.execute(credentials, uri, property, name_space, value, &b)
      begin
        options = {}
        options[:path] = uri
        headers = options[:headers] ||= {}
        headers['Cookie'] = credentials.auth_cookie if credentials.auth_cookie
        options[:body] = request_body(property, name_space, value)

        response = self.exchange_request(credentials, options)
        case response
        when Net::HTTPClientError then
          self.authenticate(credentials)
          #repeat exchange_request after authentication with the auth-cookies
          headers = options[:headers] ||= {}
          headers['Cookie'] = credentials.auth_cookie if credentials.auth_cookie
          response = self.exchange_request(credentials, options)
        end
        yield response if b
        response
      rescue RException => e
        raise e
      rescue Exception => e
        raise RException.new(options[:request], response, e)
      end
    end

  end

end
