class Destination
  class WeeklyEmailDigest < EmailDigest
    DEFAULT_DAY_OF_WEEK = "thursday"

    DAYS_OF_WEEK =
      %i[
        monday
        tuesday
        wednesday
        thursday
        friday
        saturday
        sunday
      ].map do |day_of_week|
        [I18n.t("parameters.days_of_week.#{day_of_week}"), day_of_week.to_s]
      end

    def self.day_of_week_parameter
      {
        name: :day_of_week,
        type: :list,
        default: DEFAULT_DAY_OF_WEEK,
        options: DAYS_OF_WEEK
      }
    end

    def self.parameters_for(user)
      [
        day_of_week_parameter,
        hour_parameter,
        subject_parameter,
        body_format_parameter,
        body_parameter,
        to_parameter_for(user)
      ]
    end

    def items
      destination.items.where(created_at: 1.week.ago..)
    end
  end
end
