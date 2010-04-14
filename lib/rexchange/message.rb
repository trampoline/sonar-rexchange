require 'rexchange/generic_item'
require 'rexchange/dav_proppatch_request'

module RExchange
  class Message < GenericItem

    set_folder_type 'mail'

    attribute_mappings :from => 'urn:schemas:httpmail:from',
            :to => 'urn:schemas:httpmail:to',
            :message_id => 'urn:schemas:mailheader:message-id',
            :subject => 'urn:schemas:httpmail:subject',
            :recieved_on => 'urn:schemas:httpmail:date',
            :importance => 'urn:schemas:httpmail:importance',
            :has_attachments? => 'urn:schemas:httpmail:hasattachment',
            :body => 'urn:schemas:httpmail:textdescription',
            :html => 'urn:schemas:httpmail:htmldescription'


    # Move this message to the specified folder.
    # The folder can be a string such as 'inbox/archive' or a RExchange::Folder.
    # === Example
    #   mailbox.inbox.each do |message|
    #     message.move_to mailbox.inbox.archive
    #   end
    def move_to(folder)
      destination =
              if folder.is_a?(RExchange::Folder)
                folder.to_s.ensure_ends_with('/') + self.href.split('/').last
              else
                @session.uri.path.ensure_ends_with('/') + folder.to_s.ensure_ends_with('/') + self.href.split('/').last
              end

      DavMoveRequest.execute(@session, self.href, destination)
    end

    # Delete this message.
    # === Example
    #   mailbox.inbox.each do |message|
    #     message.delete!
    #   end
    def delete!
      response = DavDeleteRequest.execute(@session, self.href)
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
      "To: #{to}, From: #{from}, Subject: #{subject}"
    end

    def raw
      fetch(href, limit = 10)
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
        response.error!
      end
    end

    def mark_as_read
      response = DavProppatchRequest.execute(@session, self.href, RExchange::PR_HTTPMAIL_READ, RExchange::NS_HTTPMAIL, 1)
      case response
      when Net::HTTPSuccess then
        true
      else
        false
      end
    end

  end
end