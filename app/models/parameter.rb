class Parameter < ApplicationRecord
  belongs_to :parameterizable, polymorphic: true

  TO = "to"

  def duplicate_for(user)
    if key == TO
      Parameter.new(key: key, value: user&.emails&.first&.email)
    else
      Parameter.new(key: key, value: value)
    end
  end
end
