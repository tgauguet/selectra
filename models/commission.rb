class Commission < Bill
  attr_accessor :data

  YEARLY_INSURANCE_FEE = 365 * 0.05

  def initialize(data)
    @data = data
  end

  def to_hash
    data[:price] += 50 if data[:penality]
    insurance_fee = data[:year_sum] * YEARLY_INSURANCE_FEE
    provider_fee = (data[:price] - insurance_fee).round(2)
    selectra_fee = (provider_fee * 12.5 / 100).round(2)

    { insurance_fee: insurance_fee, provider_fee: provider_fee, selectra_fee: selectra_fee }
  end

end
