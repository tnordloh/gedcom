#!/usr/bin/env ruby
require 'rexml/document'
Line = Struct.new(:level,:name,:data)

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
class Gedcom
  def initialize root_node
    @root_node = REXML::Element.new root_node
    @stack = []
    @curline = nil
  end
  def process_line line
    curline = parse_line line
    if is_level_0? curline
      add_stack_to_root
      @stack << curline
    else
      @stack << curline
    end
  end
  def parse_line line
    level,name,data = line.split %r{\s+}, 3
    @curline = Line.new(level.to_i,name,data)
  end
  def is_level_0? line
    line.level == 0 && @stack.size != 0
  end
  def add_stack_to_root
    @root_node.add parse_stack 
    @stack = []
  end
  #determine if current line's 'depth' is greater than, equal to, or less than the next line
  #push or pop the depth stack accordingly.
  def set_level current_depth, current_element, curline,nextline
    if nextline.level > curline.level
      current_depth.push current_element 
    elsif nextline.level < curline.level
      current_depth.pop 
    end
    #if depths are equal, or next item doesn't exist, return same level
    current_depth
  end
  def parse_stack 
    current_depth= []
    el =create_element @stack.shift 
    current_depth << el
    @stack.each_with_index {|line,i|
      myel = create_element line 
      current_depth[-1].add_element myel
      current_depth= set_level current_depth,myel,line,@stack[i+1] if @stack[i+1] != nil
    }
    el
  end
  def create_element(element)
    if element.name == "NAME" && element.data =~ /\//
      create_name_element Fullname.new(element.data)
    elsif element.name =~ /@/
      create_attribute_element element
    else
      create_standard_element element
    end
  end
  def create_name_element name
    name_xml = create_given_name_element name.full_name
    name_xml.add_element create_given_name_element name.given_name
    name_xml.add_element create_surname_element name.surname if name.surname != nil
    name_xml
  end
  def create_given_name_element full_name
    create_standard_element Line.new 0,"NAME",full_name
  end
  def create_given_name_element givn
    create_standard_element Line.new 0,"GIVN",givn
  end
  def create_surname_element surname
    create_standard_element Line.new 0,"SURN",surname
  end
  def create_attribute_element line
    el = REXML::Element.new line.data
    el.add_attribute "ID", line.name
    el
  end
  def create_standard_element line
    el = REXML::Element.new line.name
    el.text=line.data
    el
  end
  def print
    #since there might be an element still in the stack, add it before printing
    add_stack_to_root if @stack.size > 0 
    REXML::Formatters::Pretty.new.write @root_node, $stdout
    puts
  end
end
