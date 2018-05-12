class Bill
  attr_reader :level, :index, :user_id
  attr_accessor :data

  def initialize(attributes)
    @data = attributes
    @user_id = data.user ? data.user.id : data.id
    @index = data.index
    @level = data.level
  end

  def generate
    data.duration = contract_duration_in_years
    data.consumption = Consumption.total(data)

    price = Price.new(data)
    price.with_discount unless level == 1
    price.green if data.green

    if (3..6) === level
      commission =  Commission.new(price: price.total, year_sum: data.duration, penality: data.penality)
                              .to_hash

      { commission: commission, id: index, price: price.total.round(2).to_format, user_id: user_id }
    else
      { id: index, price: price.total.round(2).to_format, user_id: user_id }
    end
  end

  private

  def contract_duration_in_years
    if level == 1
      1
    elsif data.contract_length
      data.contract_length
    else
      (Date.parse(data.end_date) - Date.parse(data.start_date)).to_i / 365
    end
  end

end
