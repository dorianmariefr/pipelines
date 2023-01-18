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

  RESULT_TYPES =
    %w[mixed recent popular].map { |result_type| [result_type, result_type] }

  LIMIT_FREE = 5
  LIMITS = [1, 5, 10, 20]

  LIMITS_FREE =
    LIMITS.map do |limit|
      [
        limit.to_s,
        (
          if (limit > LIMIT_FREE)
            I18n.t("parameters.limit_disabled", limit: limit)
          else
            limit.to_s
          end
        ),
        limit > LIMIT_FREE
      ]
    end

  LIMITS_PRO = LIMITS.map { |limit| [limit.to_s, limit.to_s] }

  BODY_FORMATS = %w[text html].map { |body_format| [body_format, body_format] }

  TRANSLATED_KEYS = %w[day_of_week body_format]

  belongs_to :parameterizable, polymorphic: true

  def translated_key
    I18n.t("parameters.#{key}")
  end

  def translated_value
    TRANSLATED_KEYS.include?(key) ? I18n.t("parameters.#{value}") : value
  end

  def duplicate_for(user)
    Parameter.new(key: key, value: value)
  end

  def to_s
    "#{translated_key}: #{translated_value}"
  end
end
