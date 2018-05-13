module Consumption

  class << self

    def total(data)
      return data.yearly_consumption if data.level == 1

      data.level == 6 ? seasonal_consumption(data) : data.user.yearly_consumption * data.duration
    end

    private

    def seasonal_consumption(data)
      kwh = data.user.yearly_consumption / 4
      final_consumption = 0
      start_month = Date.parse(data.start_date).month
      seasons = { name: "spring", operator: :+, percent: 1 },
                { name: "summer", operator: :-, percent: 1.5 },
                { name: "autumn", operator: :+, percent: 0.7 },
                { name: "winter", operator: :+, percent: 0 }

      data.duration.times do |index|
        consumption = 0

        seasons.each do |s|
          amount = kwh * s[:percent] / 100
          if s[:name] == "autumn" && index == 0 && (start_month < 3 || start_month > 11)
            tmp = (kwh.public_send(s[:operator], amount) + (consumption / 2)) / 2
          else
            tmp = kwh.public_send(s[:operator], amount)
          end
          consumption += tmp
        end

        final_consumption += consumption
      end
      final_consumption
    end
    
  end

end
