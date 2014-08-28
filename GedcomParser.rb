#!/usr/bin/env ruby
require_relative 'MyElement'

class Fullname 
  attr_reader :given_name, :surname
  def initialize raw_name
    @raw_name = raw_name
    @given_name,@surname=raw_name.split(/\s*\//)
  end
  def full_name
    @raw_name.gsub(/\//," ")
  end
end

class ID
  attr_reader :name
  def initialize name,data
    #the original data comes in backwards, so I'm switching them here'
    @name,@data = data,name
    @Attribute = Struct.new(:name,:data)
  end
  def attribute_data
    @data
  end
  def attribute_name
    "ID"
  end
  def attribute
    @Attribute.new(attribute_name, attribute_data)
  end
end

class GedcomParser
  def initialize list
    @list = list
    p   @list.class
  end
  def each 
    stack = []
    @list.each {|line|
      line.chomp! 
      next if  line.empty?
      curline = parse_line line
      if is_level_0? curline, stack
        yield parse_stack stack
        stack = []
      end
      stack << curline
    }
  end
  def parse_line line
    level,name,data = line.split %r{\s+}, 3
    if name =~ /NAME/
      my_name = Fullname.new(data)
      returnme = MyElement.new(level.to_i,name,my_name.full_name)
      returnme.add_child( MyElement.new(level.to_i+1,"GIVN",my_name.given_name))
      returnme.add_child( MyElement.new(level.to_i+1,"SURN",my_name.surname))
      returnme
    elsif name =~ /@/
      my_id = ID.new(name,data)
      MyElement.new(level.to_i,my_id.name,nil,my_id.attribute)
    else
      MyElement.new(level.to_i,name,data)
    end
  end
  def is_level_0? line, stack
    line.level == 0 && stack.size != 0
  end
  #determine if current line's 'depth' is greater than, equal to, or less than the next line
  #push or pop the depth stack accordingly.
  def set_level current_depth, current_element,next_element
    if next_element.level > current_element.level
      current_depth.push current_element 
    elsif next_element.level < current_element.level
      current_depth.pop 
    end
    #if depths are equal, or next item doesn't exist, return same level
    current_depth
  end
  def parse_stack stack
    current_depth= []
    current_depth << stack.shift
    el = current_depth[0]
    stack.each_with_index {|current_element,i|
      current_depth[-1].add_child current_element
      current_depth= set_level current_depth,current_element,stack[i+1] if stack[i+1] != nil
    }
    el
  end
end
