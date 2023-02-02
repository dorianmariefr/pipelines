class Destination
  class MonthlyEmailDigest < EmailDigest
    DEFAULT_DAY_OF_MONTH = 1
    DAYS_OF_MONTH = (1..31).map { |day_of_month| [day_of_month, day_of_month] }

    def self.day_of_month_parameter
      {
        name: :day_of_month,
        type: :select,
        default: DEFAULT_DAY_OF_MONTH,
        options: DAYS_OF_MONTH
      }
    end

    def self.parameters_for(user)
      [
        day_of_month_parameter,
        hour_parameter,
        subject_parameter,
        body_format_parameter,
        body_parameter,
        to_parameter_for(user)
      ]
    end

    def items
      destination.items.where(created_at: 1.month.ago..)
    end
  end
end
