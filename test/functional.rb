require 'test/unit'
require 'rexchange'

class FunctionalTests < Test::Unit::TestCase
  
  def setup
    @mailbox = RExchange::Session.new 'url', 'username', 'password'
  end
  
  def teardown
    @mailbox = nil
  end
  
  # Ok, so it's not a real test, but I needed to get started,
  # and get rid of console scripts.
  def test_no_exceptions

    @mailbox.inbox.search(:from => 'scott').each do |m|
      puts m.subject
    end
    
  end
end