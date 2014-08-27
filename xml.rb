require_relative 'MyElement'
class XmlWriter
  def initialize tree
    @tree = tree
    @xml_tree = nil
  end
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
  def print
    @xml_tree = create_tree @tree
    REXML::Formatters::Pretty.new.write @xml_tree, $stdout
    puts
  end
end
