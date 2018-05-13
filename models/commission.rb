class Commission < Bill
  attr_accessor :data, :price

  YEARLY_INSURANCE_FEE = 365 * 0.05

  def initialize(price, data)
    @price = price
    @data = data
  end

  def to_hash
    pr = price.total
    pr += 50 if data.penality && data.provider.cancellation_fee
    insurance_fee = data.duration * YEARLY_INSURANCE_FEE
    provider_fee = (pr - insurance_fee).round(2)
    selectra_fee = (provider_fee * 12.5 / 100).round(2)

    { insurance_fee: insurance_fee, provider_fee: provider_fee, selectra_fee: selectra_fee }
  end

end
