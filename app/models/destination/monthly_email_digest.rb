class Destination
  class MonthlyEmailDigest < EmailDigest
    def self.day_of_month_parameter
      {
        default: "1",
        kind: :select,
        translate: false,
        options: Parameter::DAYS_OF_MONTH
      }
    end

    def self.as_json
      {
        destinable_type: destinable_type,
        destinable_label: destinable_label,
        parameters: {
          hour: hour_parameter,
          day_of_month: day_of_month_parameter,
          subject: subject_parameter,
          body_format: body_format_parameter,
          body: body_parameter
        }
      }
    end

    def items
      destination.items.where(created_at: 1.month.ago..)
    end
  end
end
