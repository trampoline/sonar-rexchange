require 'rexchange/exchange_request'

module RExchange
  # Used to make a new collection (aka folder).
  class DavMkcolRequest < ExchangeRequest
    METHOD = 'MKCOL'
    REQUEST_HAS_BODY = false
    RESPONSE_HAS_BODY = false
    
    def self.execute(credentials, folder_url, &b)
      begin
        options = {
          :path => folder_url
        }
        
        response = super credentials, options
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
