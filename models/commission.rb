class Commission < Bill
  attr_accessor :price

  YEARLY_INSURANCE_FEE = 365 * 0.05
  SELECTRA_PERCENTAGE = 12.5
  PENALITY = 50

  def initialize(price, data)
    super(data)
    @price = price
  end

  def to_hash
    pr = price.total
    pr += PENALITY if data.penality && data.provider.cancellation_fee
    insurance_fee = data.duration * YEARLY_INSURANCE_FEE
    provider_fee = (pr - insurance_fee).round(2)
    selectra_fee = (provider_fee * SELECTRA_PERCENTAGE / 100).round(2)

    { commission: { insurance_fee: insurance_fee, provider_fee: provider_fee, selectra_fee: selectra_fee } }
  end

end
