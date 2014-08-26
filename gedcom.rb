#!/usr/bin/env ruby
require 'rexml/document'
require './name'
class Gedcom
  def self.parse_stack stack
    current_level= []
    el =Gedcom.create_element stack.shift 
    current_level << el
    stack.each_with_index {|item,i|
      myel = Gedcom.create_element item 
      current_level[-1].add_element myel
      my_peek = stack[i+1]
      if my_peek != nil 
        if my_peek[0] > item[0]
          current_level.push myel
        elsif my_peek[0] < item[0]
          current_level.pop
        end
      end
    }
    el
  end
  def self.create_element(element)
    if element[1] == "NAME" && element[2] =~ /\//
      Name.new(element[2]).name_xml
    else
      el = REXML::Element.new element[1]
      el.text=element[2]
      el
    end
  end
end
