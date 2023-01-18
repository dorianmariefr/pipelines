class Destination
  class HourlyEmailDigest < EmailDigest
    def self.as_json
      {
        destinable_type: destinable_type,
        destinable_label: destinable_label,
        parameters: {
          subject: subject_paramater,
          body_format: body_format_parameter,
          body: body_parameter
        }
      }
    end

    def items
      destination.items.where(created_at: 1.hour.ago..)
    end
  end
end
