#!/usr/bin/env ruby
require 'rexml/document'
require_relative 'name'
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
      add_stack
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
  def add_stack
    @root_node.add parse_stack 
    @stack = []
  end
  def set_level current_level, element, item1,item2 = nil
    if item2 != nil
      if item2.level > item1.level
        current_level.push element 
      elsif item2.level < item1.level
        current_level.pop 
      end
    end
    #if levels are equal, or next item doesn't exist, return same level
    current_level
  end
  def parse_stack 
    current_level= []
    el =create_element @stack.shift 
    current_level << el
    @stack.each_with_index {|item,i|
      myel = create_element item 
      current_level[-1].add_element myel
      current_level= set_level current_level,myel,item,@stack[i+1] 
    }
    el
  end
  def create_element(element)
    if element.name == "NAME" && element.data =~ /\//
      create_name_element element
    elsif element.name =~ /@/
      create_attribute_element element
    else
      create_standard_element element
    end
  end
  def create_name_element element
    name=Fullname.new(element.data)
    name_xml = create_given_name_element name.full_name
    name_xml.add_element create_given_name_element name.given_name
    if name.surname != nil
      name_xml.add_element create_surname_element name.surname
    end
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
    REXML::Formatters::Pretty.new.write @root_node, $stdout
    puts
  end
end
