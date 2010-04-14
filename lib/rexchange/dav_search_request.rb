require 'rexchange/exchange_request'

module RExchange
  # Used for arbitrary SEARCH requests
  class DavSearchRequest < ExchangeRequest
    METHOD = 'SEARCH'
  end
end