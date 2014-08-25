#!/usr/bin/env ruby
require 'rexml/document'
include REXML
require './name'
require './gedcom'
#main code.  Create root element
gedcom = Element.new "GEDCOM"
#empty stack, used to push and pop the relevant xml elements
mystack=[]
File.open('royal.ged').each_line do |line|
  line.chomp!
  next if line.empty? 
  #if the current line is "0", and stack isn't empty, pass this section to the xml parser
  #second condition deals with the first run, where mystack hasn't been initialized yet'
  if line[0] == "0" && mystack.size != 0
    gedcom.add Gedcom.parse_stack mystack
    mystack = []
  end
  number,name,data = line.split %r{\s+}, 3
  mystack << [number.to_i,name,data]
  #  puts "#{number}:#{name}:#{data}"
end
Formatters::Pretty.new.write gedcom, $stdout
#printer.write gedcom, $stdout
puts
