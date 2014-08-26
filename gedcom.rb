#!/usr/bin/env ruby
require 'rexml/document'
require_relative 'name'
Line = Struct.new(:level,:name,:data)

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
    elsif element.name =~ /@ID@/
      create_standard_element element
    else
      create_standard_element element
    end
  end
  def create_name_element element
    Name.new(element.data).name_xml
  end
  def create_standard_element element
    el = REXML::Element.new element.name
    el.text=element.data
    el
  end
  def print
    REXML::Formatters::Pretty.new.write @root_node, $stdout
    puts
  end
end
