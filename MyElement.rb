
class MyElement
  attr_reader :level, :name, :data, :attribute
  def initialize level, name = nil, data = nil, attribute = nil
    @level,@name,@data,@attribute = level,name,data,attribute
    @children = []
  end
  def add_child element
    @children << element
  end
  def get_children
    return @children
  end
end
