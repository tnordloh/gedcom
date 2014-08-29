require 'rexml/document'
require_relative 'MyElement'

class XmlWriter
  def initialize out
    @out = out
  end
  def write tree
    my_tree = create_tree tree
    printer = REXML::Formatters::Pretty.new
    printer.compact = true
    printer.write my_tree, @out
    puts
  end
private
  def create_tree tree
    el = REXML::Element.new tree.name
    el.text=tree.data if tree.data != nil
    if(tree.attribute != nil) 
      el.add_attribute tree.attribute.name, tree.attribute.data
    end
    tree.get_children.each {|child|
      el.add_element create_tree child
    }
    el
  end
end
