class Bill
  attr_accessor :providers, :users

  def initialize(*args)
    content = JSON.parse(*args, object_class: OpenStruct)

    @providers = content.providers
    @users = content.users
  end

  def generate_bills
    bills = []

    self.users.each_with_index do |user, index|
      price_per_kwh = self.providers.find{ |p| p.id == user.provider_id }["price_per_kwh"]

      price = (price_per_kwh * user.yearly_consumption).to_i
      tmp = { id: (index + 1), price: price, user_id: user.id }
      bills << tmp
    end

    content = {:bills => bills}
    Json.generate("level1", content)
  end

end
