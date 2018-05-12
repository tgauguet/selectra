class Bill
  attr_accessor :query, :index, :level, :user_id, :consumption

  def initialize(query)
    @query = query
    @index = query.index
    @level = query.level
    @consumption = level == 1 ? query.yearly_consumption : query.user.yearly_consumption
    @user_id = query.user ? query.user.id : query.id
  end

  def generate_bill
    contract_length = calculate_contract_length
    price = base_price.to_f
    price = price_with_discount(price, contract_length) unless level == 1
    price = green_contract_price(price) if query.green

    if (3..6) === level
      commission =  Commission.new(price: price, year_sum: contract_length)
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

  def price_with_discount(price, contract_length)
    discount = case contract_length.to_i
      when 1 then 10
      when 2,3 then 20
      when 3..Float::INFINITY then 25
    end

    price = (price - (price * discount / 100)).to_f if discount
  end

  def green_contract_price(price)
    price - consumption * 0.05
  end

  def calculate_contract_length
    if query.contract_length || level == 1
      query.contract_length
    else
      end_date = Date.parse(query.end_date)
      start_date = Date.parse(query.start_date)
      (end_date - start_date).to_i / 365
    end
  end

end
