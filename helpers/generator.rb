class Generator
  attr_accessor :users, :providers, :contracts, :contract_modifications, :content, :level

  def initialize(content)
    @level = content.level
    @users = content.users
    @providers = content.providers
    @contracts = content.contracts
    @contract_modifications = content.contract_modifications
  end

  def process
    bills = []

    case self.level
      when 1

        self.users.each.with_index(1) do |user, index|
          user.index = index
          user.level = self.level
          user.provider = get_provider_by(user.provider_id)

          bill = Bill.new(user)
          bills << bill.generate_bill
        end

      when 2,3,4,5,6

        self.contracts.each.with_index(1) do |contract, index|
          contract.index = index
          contract.level = self.level
          contract.user = get_user_by(contract.user_id)
          contract.provider = get_provider_by(contract.provider_id)

          bill = Bill.new(contract)
          bills << bill.generate_bill
        end

        if [5,6].include?(level)
          self.contract_modifications.each.with_index(1) do |modification, index|
          end
        end
    end

    # store content & generate json
    content = {:bills => bills}
    Json.generate(level, content)
  end

  private

  def get_provider_by(id)
    self.providers.find{ |p| p.id == id }
  end

  def get_user_by(id)
    self.users.find{ |p| p.id == id }
  end

end
