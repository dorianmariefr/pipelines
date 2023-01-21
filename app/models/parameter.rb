class Parameter < ApplicationRecord
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
