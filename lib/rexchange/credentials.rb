require 'uri'

module RExchange

  # Credentials are passed around between Folders to emulate a stateful
  # connection with the RExchange::Session
  class Credentials
    attr_reader :user, :password, :dav_uri, :owa_uri
    attr_accessor :auth_cookie

    # You must pass a dav_uri, owa_uri, a username and a password
    def initialize(dav_uri = nil, owa_uri = nil, username = nil, password = nil)
      owa_uri = nil if owa_uri && owa_uri.blank?
      @dav_uri = URI.parse(dav_uri) if dav_uri
      @owa_uri = URI.parse(owa_uri) if owa_uri
      @dav_use_ssl = @dav_uri.scheme ? (@dav_uri.scheme.downcase == 'https') : false
      @user = username || (@dav_uri && @dav_uri.userinfo ? @dav_uri.userinfo.split(':')[0] : nil) || (@owa_uri && @owa_uri.userinfo ? @owa_uri.userinfo.split(':')[0] : nil)
      @password = password || (@dav_uri && @dav_uri.userinfo ? @dav_uri.userinfo.split(':')[1] : nil) || (@owa_uri && @owa_uri.userinfo ? @owa_uri.userinfo.split(':')[1] : nil)
      @dav_port = (@dav_uri.port || @dav_uri.default_port) if @dav_uri
      @owa_port = (@owa_uri.port || @owa_uri.default_port) if @owa_uri
      if block_given?
        yield self
      else
        return self
      end
    end
    
    def dav_use_ssl?
      @dav_use_ssl
    end

    def is_owa?
      @owa_uri && @owa_uri.scheme && @owa_uri.host
    end
    
  end
  
end