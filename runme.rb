#!/usr/bin/env ruby

require_relative 'XmlWriter'
require_relative 'GedcomParser'

parser=GedcomParser.new(File.open('royal.ged'))
writer = XmlWriter.new($stdout)
parser.each do |tree|
  writer.write(tree)
end

puts
