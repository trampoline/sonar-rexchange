require 'uri'
require 'rexchange/folder'
require 'rexchange/credentials'

module RExchange 

  class Session < Folder
    
    # Creates a Credentials instance to pass to subfolders
    # === Example
    #   RExchange::Session.new('https://mydomain.com/exchange/demo', 'https://mydomain.com/owa/auth/owaauth.dll', 'mydomain\\bob', 'secret') do |mailbox|
    #     mailbox.test.each do |message|
    #       puts message.subject
    #     end
    #   end
    def initialize(dav_uri, owa_uri, username = nil, password = nil)
    
      @credentials = Credentials.new(dav_uri, owa_uri, username, password)
      @parent = @credentials.dav_uri.path
      @folder = ''
      @href = @credentials.dav_uri.to_s
      
      yield(self) if block_given?
    end
      
  end 

end
