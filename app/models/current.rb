class Current < ActiveSupport::CurrentAttributes
  attribute :user

  delegate :pro?, to: :user, allow_nil: true
end
