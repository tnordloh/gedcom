
class MyElement
  attr_reader :level, :name, :data, :attribute
  def initialize level, name = nil, data = nil, attribute = nil
    @level,@name,@data,@attribute = level,name,data,attribute
    @children = []
  end
  def add_child element
    @children << element
  end
  def print header= ""
    puts "#{header}#{level}:#{name}:#{data}:#{attribute}"
    header = header + " "
    @children.each {|child| child.print header}
  end
  def get_children
    return @children
  end
end
