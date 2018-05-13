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
        file_path = "#{Dir.pwd}/output/json/level#{level}_#{Time.now.to_i}.json"

        File.open(file_path, "w") do |f|
          f.write(JSON.pretty_generate(content))
        end
        Command.show_result(file_path)
      rescue
        puts "An error occured while creating your JSON file."
      end
    end

  end

end
