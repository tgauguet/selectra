module BillGenerator
  extend self

  def process(json)
    init_process(json)

    create_bills_list

    json = { :bills => @bills }
    Json.generate(@level, json)
  end

  private

  def init_process(json)
    @bills = []
    @level = json.level
    @users = json.users
    @providers = json.providers
    @contracts = json.contracts
    @contract_modifications = json.contract_modifications
  end

  def create_bills_list
    sup_index = 0
    model = @level == 1 ? @users : @contracts

    model.each.with_index(1) do |model, index|
      set_model_variables(model, index + sup_index)

      if model.modifications&.any?
        sup_index += model.modifications.count - 1

        create_bills_with_modifications(model)
      else
        store_current_bill(model)
      end
    end
  end

  def create_bills_with_modifications(model)
    model.modifications.each.with_index do |modification, i|
      modification = modification.to_h
      model.index += 1 unless i == 0
      model.penality = modification[:provider_id].nil? ? 1 : nil

      modification.each do |key, value|
        model[key] = value unless model[key].nil?
      end
      model.provider = get_provider_by(model.provider_id)

      store_current_bill(model)
    end
  end

  def store_current_bill(model)
    @bills << Bill.new(model)
                  .generate
  end

  def set_model_variables(model, index)
    model.index = index
    model.level = @level
    model.provider = get_provider_by(model.provider_id)
    model.user = get_user_by(model.user_id) if model.user_id
    model.modifications = get_modification_by(model.id) if @contract_modifications
    model
  end

  def get_provider_by(id)
    @providers.find{ |p| p.id == id }
  end

  def get_user_by(id)
    @users.find{ |p| p.id == id }
  end

  def get_modification_by(id)
    @contract_modifications.select{ |p| p.contract_id == id }
  end

end
