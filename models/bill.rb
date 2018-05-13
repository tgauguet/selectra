class Bill
  attr_reader :level, :index, :user_id
  attr_accessor :data

  def initialize(attributes)
    @data = attributes
    @user_id = data.user ? data.user.id : data.id
    @index = data.index
    @level = data.level
    @price = data.price
  end

  def generate
    data.duration = contract_duration_in_years
    data.consumption = Consumption.total(data)

    price = Price.new(data)
    price.with_discount unless level == 1
    price.green         if data.green

    bill = (3..6) === level ? Commission.new(price, data).to_hash : {}
    bill.merge({ id: index, price: price.total.round(2).to_format, user_id: user_id })
  end

  private

  def contract_duration_in_years
    case level
    when 1 then 1
    when 2..4 then data.contract_length
    when 5..6 then (Date.parse(data.end_date) - Date.parse(data.start_date)).to_i / 365
    end
  end

end
