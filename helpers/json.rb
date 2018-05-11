module Json

  def self.valid?(file)
    JSON.parse(file)
      return true
    rescue JSON::ParserError => e
      return false
  end

  def self.generate(file_name, content)
    begin
      file_path = "#{Dir.pwd}/json/outputs/#{file_name}_#{Time.now.to_i}.json"

      File.open(file_path, "w") do |f|
        f.write(JSON.pretty_generate(content))
      end
      Command.show_result(file_path)
    rescue
      puts "An error occured while creating your file."
    end
  end

end
