class Generator
  attr_reader :level
  attr_accessor :users, :providers, :contracts, :contract_modifications, :content

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
          bills << bill.generate
        end

      when 2..6
        modification_count = 0

        self.contracts.each.with_index(1) do |contract, index|
          contract.index = index + modification_count
          contract.level = self.level
          contract.user = get_user_by(contract.user_id)
          contract.provider = get_provider_by(contract.provider_id)
          modifications = get_modifications(contract.id) if self.contract_modifications

          if modifications&.any?
            modification_count += modifications.count - 1

            modifications.each.with_index do |modification, i|
              contract.index += i
              modification = modification.to_h

              contract.penality = modification[:provider_id].nil? ? 1 : nil
              modification.each do |key, value|
                contract[key] = value unless contract[key].nil?
              end
              contract.provider = get_provider_by(contract.provider_id)

              bills <<  Bill.new(contract)
                            .generate
            end
          else
            bills <<  Bill.new(contract)
                          .generate
          end
        end
    end

    # store content & generate json
    content = { :bills => bills }
    Json.generate(level, content)
  end

  private

  def get_provider_by(id)
    self.providers.find{ |p| p.id == id }
  end

  def get_user_by(id)
    self.users.find{ |p| p.id == id }
  end

  def get_modifications(id)
    self.contract_modifications.select{ |p| p.contract_id == id }
  end

end
