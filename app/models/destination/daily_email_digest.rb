class Destination
  class DailyEmailDigest < EmailDigest
    def self.parameters_for(user)
      [
        hour_parameter,
        subject_parameter,
        body_format_parameter,
        body_parameter,
        to_parameter_for(user)
      ]
    end

    def items
      destination.items.where(created_at: 1.day.ago..)
    end
  end
end
