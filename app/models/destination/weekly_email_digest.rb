class Destination
  class WeeklyEmailDigest < EmailDigest
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
        [day_of_week.to_s, I18n.t("parameters.#{day_of_week}")]
      end

    def self.day_of_week_parameter
      {default: :thursday, kind: :select, options: DAYS_OF_WEEK}
    end

    def self.as_json
      {
        destinable_type: destinable_type,
        destinable_label: destinable_label,
        parameters: {
          hour: hour_parameter,
          day_of_week: day_of_week_parameter,
          subject: subject_parameter,
          body_format: body_format_parameter,
          body: body_parameter
        }
      }
    end

    def items
      destination.items.where(created_at: 1.week.ago..)
    end
  end
end
