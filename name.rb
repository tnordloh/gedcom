require 'rexml/document'
include REXML
#created a class to deal with the 'special case' of name
class Name
  attr_reader :name_xml
  def initialize(name)
    @name=name.delete("/")
    @givn,@surn=name.split(' /')
    if @surn == nil
      @surn = " "
    else
      @surn.delete! "/" 
    end
    @name_xml = Element.new "NAME"
    @name_xml.text=@name
    myel2 = Element.new "SURN"
    myel2.text=@surn
    myel3 = Element.new "GIVN"
    myel3.text=@givn
    @name_xml.add_element myel2
    @name_xml.add_element myel3
  end
end
