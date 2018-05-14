module Json

  class << self

    def valid?(file)
      JSON.parse(file)
        return true
      rescue JSON::ParserError => e
        return false
    end

    def generate(level, content)
      begin
        file_path = "#{Dir.pwd}/result/level#{level}_#{Time.now.to_i}.json"

        File.open(file_path, "w") do |f|
          f.write(JSON.pretty_generate(content))
        end

        Command.show_result(level, file_path)
      rescue
        puts "An error occured while creating your JSON file."
      end
    end

    def result_match?(given_file, result_file)
      JSON.parse(File.read(given_file)).eql?(JSON.parse(File.read(result_file)))
    end

  end

end
