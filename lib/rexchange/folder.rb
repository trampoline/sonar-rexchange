require 'rexml/document'
require 'net/https'
require 'rexchange/dav_search_request'
require 'rexchange/message'
require 'rexchange/contact'
require 'rexchange/appointment'
require 'rexchange/note'
require 'rexchange/task'
require 'rexchange/message_href'
require 'uri'

module RExchange

  class FolderNotFoundError < StandardError
  end

  class Folder
    include REXML

    attr_reader :credentials, :displayname

    def initialize(credentials, parent, displayname, href, content_type)
      @credentials, @parent, @href = credentials, parent, href
      @content_type = CONTENT_TYPES[content_type] || Message
      @displayname = displayname
    end

    # Used to access subfolders.
    def method_missing(sym, *args)

      if folders_hash.has_key?(sym.to_s)
        folders_hash[sym.to_s]
      else
        puts folders_hash.keys.inspect
        puts sym.to_s
        raise FolderNotFoundError.new("#{sym} is not a subfolder of #{@displayname} - #{@href}")
      end
    end

    include Enumerable

    def message_hrefs(href_regex)
      RExchange::MessageHref::find_message_hrefs(href_regex, @credentials, to_s)
    end

    # Iterate through each entry in this folder
    def each
      @content_type::find(@credentials, to_s).each do |item|
        yield item
      end
    end

    # Not Implemented!
    def search(conditions = {})
      raise NotImplementedError.new('Bad Touch!')
      @content_type::find(@credentials, to_s, conditions)
    end

    # Return an Array of subfolders for this folder
    def folders
      @folders ||=
              begin
                request_body = <<-eos
  				<D:searchrequest xmlns:D = "DAV:">
  					 <D:sql>
  					 SELECT "DAV:displayname", "DAV:contentclass"
  					 FROM SCOPE('shallow traversal of "#{@href}"')
  					 WHERE "DAV:ishidden" = false
                         AND "DAV:isfolder" = true
  					 </D:sql>
  				</D:searchrequest>
                eos
                folders = []
                DavSearchRequest.execute(@credentials, :body => request_body) do |response|


                  # iterate through folders query and add a new Folder
                  # object for each, under a normalized name.
                  xpath_query = "/*/a:response[a:propstat/a:status/text() = 'HTTP/1.1 200 OK']"
                  Document.new(response.body).elements.each(xpath_query) do |m|
                    href = m.elements['a:href'].text
                    displayname = m.elements['a:propstat/a:prop/a:displayname'].text
                    contentclass = m.elements['a:propstat/a:prop/a:contentclass'].text
                    folders << Folder.new(@credentials, self, displayname, href, contentclass.split(':').last.sub(/folder$/, ''))
                  end

                end
                folders
              end

    end

    def folders_hash
      @folders_hash ||= folders.inject({}){|memo, f| memo[f.displayname.normalize]=f; memo}
    end

    # Return the absolute path to this folder (but not the full URI)
    def to_s
      @href
    end
  end
end
