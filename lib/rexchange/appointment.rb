require 'rexchange/generic_item'

module RExchange
  class Appointment < GenericItem
    
    set_folder_type 'calendar'
    
    attribute_mappings :all_day_event => 'urn:schemas:calendar:alldayevent',
      :busy_status => 'urn:schemas:calendar:busystatus',
      :contact => 'urn:schemas:calendar:contact',
      :contact_url => 'urn:schemas:calendar:contacturl',
      :created_on => 'urn:schemas:calendar:created',
      :description_url => 'urn:schemas:calendar:descriptionurl',
      :end_at => 'urn:schemas:calendar:dtend',
      :created_at => 'urn:schemas:calendar:dtstamp',
      :start_at => 'urn:schemas:calendar:dtstart',
      :duration => 'urn:schemas:calendar:duration',
      :expires_on => 'urn:schemas:calendar:exdate',
      :expiry_rule => 'urn:schemas:calendar:exrule',          
      :has_attachment? => 'urn:schemas:httpmail:hasattachment', 
      :html => 'urn:schemas:httpmail:htmldescription',
      :modified_on => 'urn:schemas:calendar:lastmodified', 
      :location => 'urn:schemas:calendar:location', 
      :location_url => 'urn:schemas:calendar:locationurl', 
      :meeting_status => 'urn:schemas:calendar:meetingstatus', 
      :normalized_subject => 'urn:schemas:httpmail:normalizedsubject', 
      :priority => 'urn:schemas:httpmail:priority', 
      :recurres_on => 'urn:schemas:calendar:rdate', 
      :reminder_offset => 'urn:schemas:calendar:reminderoffset', 
      :reply_time => 'urn:schemas:calendar:replytime', 
      :sequence => 'urn:schemas:calendar:sequence', 
      :subject => 'urn:schemas:httpmail:subject', 
      :body => 'urn:schemas:httpmail:textdescription',
      :timezone => 'urn:schemas:calendar:timezone', 
      :uid => 'urn:schemas:calendar:uid'

  end
end  