class Bill
  attr_accessor :query, :price, :index, :level, :user_id, :consumption

  def initialize(query)
    @query = query
    @index = query.index
    @level = query.level
    @consumption = level == 1 ? query.yearly_consumption : query.user.yearly_consumption
    @price = base_price.to_f
    @price = price_with_discount unless level == 1
    @user_id = query.user ? query.user.id : query.id
  end

  def generate_bill
    if level == 3
      commission =  Commission.new(price: price, year_sum: query.contract_length)
                              .generate_commission
      { commission: commission, id: index, price: price.to_format, user_id: user_id }
    else
      { id: index, price: price.to_format, user_id: user_id }
    end
  end

  private

  def base_price
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
  end

end
