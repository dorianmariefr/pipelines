class Pipeline < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :sequentially_slugged

  belongs_to :user

  has_many :sources, dependent: :destroy
  has_many :destinations, dependent: :destroy
  has_many :items, through: :sources

  accepts_nested_attributes_for :sources, allow_destroy: true
  accepts_nested_attributes_for :destinations, allow_destroy: true

  scope :published, -> { where(published: true) }

  def self.find_by_id_or_slug!(id_or_slug)
    where(id: id_or_slug).or(where(slug: id_or_slug)).first!
  end

  def process_now
    ApplicationRecord.transaction do
      items = sources.map(&:fetch).flatten

      destinations.each do |destination|
        destination.send_now(items) if destination.instant?
      end
    end
  end

  def process_later
    ApplicationRecord.transaction do
      items = sources.map(&:fetch).flatten

      destinations.each do |destination|
        destination.send_later(items) if destination.instant?
      end
    end
  end

  def to_s
    name.presence || id
  end
end
