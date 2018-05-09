require '../../application.rb'

class YearlyBill
  attr_accessor :providers, :users

  # extract providers and users from source
  def initialize(file)
    content = JSON.parse(file, object_class: OpenStruct)

    @providers = content.providers
    @users = content.users
  end

  def generate_file
    self.users.each do |user|
      provider = self.providers.select{ |p| p.id == user.provider_id }.uniq
      puts provider
    end
  end

end

# Check file & JSON validity then process
if File.file?(ARGV[0])
  file = open(ARGV[0]).read

  if MainHelper.valid_json?(file)
    json = YearlyBill.new(file)
    json.generate_file
  else
    puts 'An error occured, please verify that your file is a valid JSON.'
  end
else
  puts 'This file does not exist, please verify file path.'
end
