#!/usr/bin/env ruby

require 'rubygems'
require 'json'

Dir['./lib/*.rb'].each { |file| require_relative file }
Dir['./models/*.rb'].each { |file| require_relative file }
Dir['./helpers/*.rb'].each { |file| require_relative file }

LEVEL, FILE_PATH = Command.get_test_informations

# Check file & JSON validity
if File.file?(FILE_PATH.to_s)
  file = open(FILE_PATH).read
  if Json.valid?(file)

    # then process
    case LEVEL
      when 1
        bill = Bill.new(file)
        bill.generate_bills
      when 2
        contract = Contract.new(file)
        contract.generate_bills
      when 3
      when 4
      when 5
      when 6
    end

  # input errors
  else
    puts 'An error occured, please verify that your file is a valid JSON.'.red
  end
else
  puts 'This file does not exist, please verify file path.'.red
end
