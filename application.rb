#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'test/unit'
require 'date'

Dir.glob(['./lib/*.rb', './models/*.rb', './helpers/*.rb']).each { |file| require_relative file }

LEVEL, FILE_PATH = Command.get_test_informations

if File.file?(FILE_PATH.to_s)
  file = open(FILE_PATH).read

  if Json.valid?(file)
    # parse file then process
    json = JSON.parse(file, object_class: OpenStruct)
    json.level = LEVEL

    BillGenerator.process(json)
  else
    puts 'An error occured, please verify that your file is a valid JSON.'.red
  end
else
  puts 'This file does not exist, please verify file path.'.red
end
