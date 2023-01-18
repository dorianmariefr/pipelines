class Destination
  class DailyEmailDigest < EmailDigest
    def self.as_json
      {
        destinable_type: destinable_type,
        destinable_label: destinable_label,
        parameters: {
          hour: hour_parameter,
          subject: subject_parameter,
          body_format: body_format_parameter,
          body: body_parameter
        }
      }
    end

    def items
      destination.items.where(created_at: 1.day.ago..)
    end
  end
end
