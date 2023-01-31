class Item < ApplicationRecord
  belongs_to :source
  has_one :pipeline, through: :source

  validates :external_id, uniqueness: { scope: :source_id }

  delegate :first_kind, :second_kind, to: :source

  def match(filter)
    return true if filter.blank?
    Code.evaluate(filter, ruby: as_json).truthy?
  end

  def duplicate_for(user)
    Item.new(external_id: external_id, extras: extras)
  end

  def as_json(...)
    {
      **extras,
      external_id: external_id,
      pipeline: pipeline.as_json(...)
    }.as_json(...)
  end
end
