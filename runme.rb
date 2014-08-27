#!/usr/bin/env ruby
require 'rexml/document'
require_relative 'xml'
require_relative 'gedcom'
#main code.  Create root element
#empty stack, used to push and pop the relevant xml elements
gedcom = Gedcom.new("GEDCOM")
File.open('royal.ged').each_line do |line|
  line.chomp!
  next if line.empty? 
  gedcom.process_line line
end
writer = XmlWriter.new(gedcom.root)
writer.print

puts
