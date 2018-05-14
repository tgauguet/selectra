module Command

  class << self

    def get_test_informations
      level = prompt("Type the desired start level (1 to 6) :\n".yellow).to_i
      custom_file = prompt("Use custom data.json file path ? (Y/n)\n".yellow).upcase

      if custom_file.eql?("Y") && (1..6).include?(level)
        file_path = prompt("Type the path to the JSON file you would like to use :\n")
      else
        file_path = "json/data/level#{level}.json"
      end
      puts "Running LEVEL #{level} with #{file_path}".blue

      return level, file_path
    end

    def show_result(level, file_path)
      result_file = "#{Dir.pwd}/json/output/level#{level}.json"

      if Json.result_match?(result_file, file_path)
        puts "Congrats ! Your result match with the required output !".light_blue
      else
        puts "Aouch ! Your result is not similar to the required output !".red
      end
      show_result = prompt("Your test has run successfully ! Show output file content ? (Y/n)\n".yellow).upcase
      if show_result.eql?("Y")
        exec "cat #{file_path}; echo"
      else
        puts "Output file path : #{file_path}".light_blue
      end
    end

    def prompt(*args)
      print(*args)
      gets.gsub("\n", '')
    end

  end

end
