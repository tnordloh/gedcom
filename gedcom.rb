#!/usr/bin/env ruby
require './constants'
require './name'
class Gedcom
  def self.parse_stack stack
    current_level= []
    el = Element.new stack[0][1]
    el.text=stack[0][2]
    current_level << el
    stack.shift
    stack.each_with_index {|item,i|
      myel = Element.new item[1]
      myel.text=item[2]
      if item[1] == "NAME" && item[2] =~ /\//
        myel = Name.new(item[2]).name_xml
      end
      if item[0].to_i==0
        current_level << myel
      else
        current_level[-1].add_element myel
      end
      my_peek = stack[i+1]
      if my_peek != nil && my_peek[0] > item[0]
        current_level << myel
      end
      if my_peek != nil && my_peek[0] < item[0]
        current_level.pop
      end
      my_peek = nil
    }
    el
  end
end

