class Pipeline < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :sequentially_slugged

  belongs_to :user

  scope :published, -> { where(published: true) }

  def self.find_by_id_or_slug!(id_or_slug)
    where(id: id_or_slug).or(where(slug: id_or_slug)).first!
  end

  def to_s
    name.presence || id
  end
end
