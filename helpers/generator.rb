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
          user = set_basics(user, index)

          bill = Bill.new(user)
          bills << bill.generate
        end

      when 2..6
        sup_index = 0
        self.contracts.each.with_index(1) do |contract, index|
          set_basics(contract, index + sup_index)
          puts contract.modifications.count

          if contract.modifications&.any?
            sup_index += contract.modifications.count - 1

            contract.modifications.each.with_index do |modification, i|
              modification = modification.to_h

              contract.index += 1 unless i == 0
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

    content = { :bills => bills }
    Json.generate(level, content)
  end

  private

  def set_basics(model, index)
    model.index = index
    model.level = self.level
    model.provider = get_provider_by(model.provider_id)
    model.user = get_user_by(model.user_id) if model.user_id
    model.modifications = get_modifications(model.id) if self.contract_modifications
  end

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
