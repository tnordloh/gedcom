#!/usr/bin/env ruby

require_relative 'xml'
require_relative 'gedcom'

parser=Gedcom.new(File.open('royal.ged'))
writer = XmlWriter.new($stdout)
parser.each do |tree|
  writer.write(tree)
end

puts
