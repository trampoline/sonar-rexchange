require 'rexchange/generic_item'

module RExchange
  class Contact < GenericItem
    
    set_folder_type 'contact'
    set_content_class 'person'

    attribute_mappings :first_name => 'urn:schemas:contacts:givenName',
      :middle_name => 'urn:schemas:contacts:middlename',
      :last_name => 'urn:schemas:contacts:sn',
      :title => 'urn:schemas:contacts:title',
      :created_at => 'DAV:creationdate',
      :address => 'urn:schemas:contacts:mailingstreet',
      :city => 'urn:schemas:contacts:mailingcity',
      :state => 'urn:schemas:contacts:st',
      :zip_code => 'urn:schemas:contacts:mailingpostalcode',
      :country => 'urn:schemas:contacts:co',
      :phone => 'urn:schemas:contacts:homePhone',
      :business_phone => 'urn:schemas:contacts:telephoneNumber',
      :fax => 'urn:schemas:contacts:facsimiletelephonenumber',
      :mobile => 'urn:schemas:contacts:mobile',    
      :email => 'urn:schemas:contacts:email1',
      :website => 'urn:schemas:contacts:businesshomepage',
      :company => 'urn:schemas:contacts:o',
      :notes => 'urn:schemas:httpmail:textdescription'

  end  
end