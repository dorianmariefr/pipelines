class Destination
  class HourlyEmailDigest < EmailDigest
    def self.parameters_for(user)
      [
        subject_parameter,
        body_format_parameter,
        body_parameter,
        to_parameter_for(user)
      ]
    end

    def items
      destination.items.where(created_at: 1.hour.ago..)
    end
  end
end
