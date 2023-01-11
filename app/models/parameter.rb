class Parameter < ApplicationRecord
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

  def to_s
    "#{translated_key}: #{translated_value}"
  end
end
