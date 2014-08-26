#!/usr/bin/env ruby
require 'rexml/document'
require_relative 'gedcom'
#main code.  Create root element
#empty stack, used to push and pop the relevant xml elements
gedcom = Gedcom.new("GEDCOM")
File.open('royal.ged').each_line do |line|
  line.chomp!
  next if line.empty? 
  #if the current line is "0", and stack isn't empty, pass this section to the xml parser
  #second condition deals with the first run, where mystack hasn't been initialized yet'
  gedcom.process_line line
  #if line[0] == "0" && mystack.size != 0
  #  gedcom.add Gedcom.parse_stack mystack
  #  mystack = []
  #end
  #level,name,data = line.split %r{\s+}, 3
  #Line = Struct.new(:level,:name,:data)
  #mystack << Line.new(number.to_i,name,data)
end
gedcom.print

puts
