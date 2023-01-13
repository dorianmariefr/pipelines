class Parameter < ApplicationRecord
  HOURS = (0..23).map { |hour| [hour.to_s, "#{hour}:00"] }

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

  DAYS_OF_MONTH =
    (1..31).map { |day_of_month| [day_of_month.to_s, day_of_month.to_s] }

  belongs_to :parameterizable, polymorphic: true

  def translated_key
    I18n.t("parameters.#{key}")
  end

  def translated_value
    if value.to_i.to_s == value
      value
    else
      I18n.t("parameters.#{value}")
    end
  end

  def duplicate_for(user)
    Parameter.new(key: key, value: value)
  end

  def to_s
    "#{translated_key}: #{translated_value}"
  end
end
