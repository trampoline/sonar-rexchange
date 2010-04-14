require 'rexchange/session'
require 'rexchange/r_exception'

class String
  def ends_with?(partial)
    self[self.size - partial.size..self.size] == partial
  end

  def ensure_ends_with(partial)
    self.ends_with?(partial) ? self : self + partial
  end

  def normalize
    self.split(/(?=[A-Z][a-z]*)/).join('_').tr('- ', '_').squeeze('_').downcase
  end
end

module RExchange
  # Use STDOUT or another stream if you'd like to capture the HTTP debug output
  DEBUG_STREAM = $log

  PR_HTTPMAIL_READ = 'read'
  NS_HTTPMAIL = 'urn:schemas:httpmail'

  # A shortcut to RExchange::Session#new
  def self.open(dav_uri, owa_uri, username = nil, password = nil)
    session = RExchange::Session.new(dav_uri, owa_uri, username, password)

    yield session if block_given?
    return session
  end

end