require 'rexchange/exchange_request'

module RExchange
  # Used for arbitrary SEARCH requests
  class DavGetRequest < ExchangeRequest
    METHOD = 'GET'
    REQUEST_HAS_BODY = false
    RESPONSE_HAS_BODY = true

    def self.execute(credentials, url, &b)
      begin
        options = {
                :path => url,
                :headers => {
                        'Translate' => 'f'   # Microsoft IIS 5.0 "Translate: f" Source Disclosure Vulnerability (http://www.securityfocus.com/bid/1578)
                }
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