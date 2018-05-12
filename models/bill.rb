class Bill
  attr_accessor :query, :price, :index, :level, :user_id

  YEARLY_INSURANCE_FEE = 365 * 0.05

  def initialize(query)
    @query = query
    @index = query.index
    @level = query.level
    @price = base_price.to_f
    @user_id = query.user ? query.user.id : query.id
  end

  def generate_hash
    price = price_with_discount if query.contract_length.to_i
    { id: index, price: price.to_format, user_id: user_id }
  end

  private

  def base_price
    consumption = level == 1 ? query.yearly_consumption : query.user.yearly_consumption
    query.provider.price_per_kwh * consumption
  end

  def price_with_discount
    discount = case query.contract_length.to_i
      when 1 then 10
      when 2,3 then 20
      when 3..Float::INFINITY then 25
    end

    if discount
      tmp = price
      tmp2 = price
      price = (tmp2 - (tmp * discount / 100)).to_f
    end

    price
  end

end
