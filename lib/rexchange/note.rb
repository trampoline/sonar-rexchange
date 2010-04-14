require 'rexchange/generic_item'

module RExchange
  class Note < GenericItem
    
    set_folder_type 'note'
   
    attribute_mappings :displayname => 'DAV:displayname',
      :created_at => 'DAV:creationdate', 
      :subject =>'urn:schemas:httpmail:subject',
      :body => 'urn:schemas:httpmail:textdescription'
      
     end  
  
  
   end
