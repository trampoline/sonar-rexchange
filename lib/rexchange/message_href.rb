require 'rexchange/dav_delete_request'
require 'rexchange/dav_proppatch_request'

module RExchange
  class MessageHref

    def initialize(session, href)
      @href = href
      @session = session
    end

    # Move this message to the specified folder.
    # The folder can be a string such as 'inbox/archive' or a RExchange::Folder.
    # === Example
    #   mailbox.inbox.each do |message|
    #     message.move_to mailbox.inbox.archive
    #   end
    def move_to(folder)

      destination =
              if folder.is_a?(RExchange::Folder)
                folder.to_s.ensure_ends_with('/') + @href.split('/').last
              else
                @session.uri.path.ensure_ends_with('/') + folder.to_s.ensure_ends_with('/') + @href.split('/').last
              end

      DavMoveRequest.execute(@session, @href, destination)
    end

    # Delete this message.
    # === Example
    #   mailbox.inbox.each do |message|
    #     message.delete!
    #   end
    def delete!
      uri_str = @href
      response = DavDeleteRequest.execute(@session, @href)
      case response.code
      when 204 then
        # Standard success response.   ( http://msdn.microsoft.com/en-us/library/aa142839(EXCHG.65).aspx )
        true
      when 423 then
        # The destination resource is locked.
        false
      end
    end

    def to_s
      "Href: #{@href}"
    end

    def raw
      fetch(@href, limit = 10)
    end

    def fetch(uri_str, limit = 10)
      # You should choose better exception.
      raise ArgumentError, 'HTTP redirect too deep' if limit == 0
      response = DavGetRequest.execute(@session, uri_str)
      case response
      when Net::HTTPSuccess     then
        response.body
      when Net::HTTPRedirection then
        fetch(response['location'], limit - 1)
      else
        puts "URI #{@href}"
        response.error!
      end
    end

    def mark_as_read
      DavProppatchRequest.execute(@session, @href, RExchange::PR_HTTPMAIL_READ, RExchange::NS_HTTPMAIL, 1)
    end

    def self.query(path)
      <<-QBODY
          SELECT
            "DAV:href"
          FROM SCOPE('shallow traversal of "#{path}"')
          WHERE "DAV:ishidden" = false
            AND "DAV:isfolder" = false

      QBODY
      # AND "DAV:contentclass" = 'urn:content-classes:message'
    end

    # Retrieve an Array of hrefs to items (such as Contact, Message, etc)
    def self.find_message_hrefs(href_regex, credentials, path, conditions = nil)
      qbody = <<-QBODY
  			<D:searchrequest xmlns:D = "DAV:">
  				 <D:sql>
           #{query(path)}
           </D:sql>
        </D:searchrequest>
      QBODY
      items = []
      DavSearchRequest.execute(credentials, :body => qbody) do |response|       
        response.body.scan(href_regex){|m|
          items << self.new(credentials, m[0]) if m[0]
        }
      end
      items
    end

  end
end