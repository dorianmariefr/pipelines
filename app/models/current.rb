class Current < ActiveSupport::CurrentAttributes
  attribute :user

  delegate :pro?, to: :user
end
