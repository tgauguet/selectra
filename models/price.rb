class Price < Bill
  attr_reader :data
  attr_accessor  :total

  def initialize(data)
    @data = data
    @total = data.provider.price_per_kwh * data.consumption
  end

  def with_discount
    discount = case data.duration.to_i
      when 1 then 10
      when 2,3 then 20
      when 3..Float::INFINITY then 25
    end

    self.total = (total - (total * discount / 100)).to_f
  end

  def green
    self.total = total - data.consumption * 0.05
  end

end
