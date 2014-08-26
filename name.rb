require 'rexml/document'
#created a class to deal with the 'special case' of name
class Name
  attr_reader :name_xml
  def initialize(name)
    @name=name.gsub!(/\//," ")
    @givn,@surn=name.split(/\s*\//)
    if @surn == nil
      @surn = " "
    else
      @surn.delete! "/" 
    end
    def name_xml
      @name_xml = REXML::Element.new "NAME"
      @name_xml.text=@name
      myel2 = REXML::Element.new "SURN"
      myel2.text=@surn
      myel3 = REXML::Element.new "GIVN"
      myel3.text=@givn
      @name_xml.add_element myel2
      @name_xml.add_element myel3
      @name_xml
    end
  end
end
