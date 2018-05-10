require '../../application.rb'

class Bill
  attr_reader :file
  attr_accessor :providers, :users

  # extract providers and users from source
  def initialize(file)
    content = JSON.parse(file, object_class: OpenStruct)

    @providers = content.providers
    @users = content.users
  end

  def generate_bills
    bills = []

    self.users.each_with_index do |user, index|
      provider = self.providers.select{ |p| p.id == user.provider_id }.first
      price = (provider.price_per_kwh * user.yearly_consumption).to_i
      tmp = { id: (index + 1), price: price, user_id: user.id }
      bills << tmp
    end

    res = {:bills => bills}
    # Create json file
    File.open("json/output.json", "w") { |f| f.write(JSON.pretty_generate(res)) }
  end

end

# Check file & JSON validity then process
if File.file?(ARGV[0])
  file = open(ARGV[0]).read
  if MainHelper.valid_json?(file)
    json = Bill.new(file)
    json.generate_bills
  else
    puts 'An error occured, please verify that your file is a valid JSON.'
  end
else
  puts 'This file does not exist, please verify file path.'
end
