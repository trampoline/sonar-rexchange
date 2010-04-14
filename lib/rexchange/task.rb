require 'rexchange/generic_item'

module RExchange
  class Task < GenericItem
    
    set_folder_type 'task'
   
    attribute_mappings :displayname => 'DAV:displayname',
      :created_at => 'DAV:creationdate', 
      :subject =>'urn:schemas:httpmail:subject',
      :body => 'urn:schemas:httpmail:textdescription',
      :percent_complete =>'http://schemas.microsoft.com/exchange/tasks/percentcomplete',
      :owner =>'http://schemas.microsoft.com/exchange/tasks/owner',
      :is_complete =>'http://schemas.microsoft.com/exchange/tasks/is_complete',
      :date_start =>'http://schemas.microsoft.com/exchange/tasks/dtstart',
      :date_due =>'http://schemas.microsoft.com/exchange/tasks/dtdue',
      :actual_effort =>'http://schemas.microsoft.com/exchange/tasks/actualeffort', 
      :estimated_effort =>'http://schemas.microsoft.com/exchange/tasks/estimatedeffort',
      :priority =>'http://schemas.microsoft.com/mapi/priority',
      :status =>'http://schemas.microsoft.com/exchange/tasks/status',
      :state =>'http://schemas.microsoft.com/exchange/tasks/state'
      
     end  
  
  
   end
