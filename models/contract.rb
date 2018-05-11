class Contract
  attr_accessor :users, :providers, :contracts

  def initialize(*args)
    content = JSON.parse(*args, object_class: OpenStruct)

    @providers = content.providers
    @users = content.users
    @contracts = content.contracts
  end

  def generate_bills
    bills = []

    self.contracts.each_with_index do |contract, index|
      user = self.users.find{ |p| p.id == contract.user_id }
      price_per_kwh = self.providers.find{ |p| p.id == contract.provider_id }["price_per_kwh"]

      discount = case contract.contract_length.to_i
        when 1 then 10
        when 2,3 then 20
        when 3..100 then 25
        else
          nil
      end

      if discount
        price = (price_per_kwh * user.yearly_consumption)
        price_with_reduction = (price - (price * discount / 100)).to_f
        tmp = { id: (index + 1), price: price_with_reduction.to_format, user_id: user.id }
        bills << tmp
      end
    end

    content = {:bills => bills}
    Json.generate("level2", content)
  end

end
