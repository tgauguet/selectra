module Consumption

  def self.total(data)
    return data.yearly_consumption if data.level == 1

    consumption = data.user.yearly_consumption * data.duration
    if data.level == 6
      seasons = { name: "spring", operator: :+, percent: 1, days_sum: 92, starts: "03-01", ends: "05-31" },
                { name: "summer", operator: :-, percent: 1.5, days_sum: 92, starts: "06-01", ends: "08-31" },
                { name: "autumn", operator: :+, percent: 0.7, days_sum: 91, starts: "09-01", ends: "11-30" },
                { name: "winter", operator: :+, percent: 0, days_sum: 90, starts: "11-01", ends: "02-28" }

      kwh = consumption / 4
      consumption = 0
      seasons.each do |s|
        amount = kwh * s[:percent] / 100

        if s[:name] == "autumn"
          tmp = (kwh.public_send(s[:operator], amount) + (consumption / 2)) / 2
        else
          tmp = kwh.public_send(s[:operator], amount)
        end
        consumption += tmp
      end
    end
    consumption
  end

end
