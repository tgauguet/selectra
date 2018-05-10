module MainHelper

  def self.valid_json?(file)
    JSON.parse(file)
      return true
    rescue JSON::ParserError => e
      return false
  end

end
