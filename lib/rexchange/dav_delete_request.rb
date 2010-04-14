require 'rexchange/exchange_request'

module RExchange
  # Used to move entities to different locations in the accessable mailbox.
  class DavDeleteRequest < ExchangeRequest
    METHOD = 'DELETE'
    REQUEST_HAS_BODY = false
    RESPONSE_HAS_BODY = false

    def self.execute(credentials, source, &b)
      begin
        options = {
                :path => source
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
