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

      destinations.each { |destination| destination.send_now(items) }
    end
  end

  def process_later
    ApplicationRecord.transaction do
      items = sources.map(&:fetch).flatten

      destinations.instant.each { |destination| destination.send_later(items) }
    end
  end

  def duplicate_for(user)
    pipeline = Pipeline.new(name: name, published: false, user: user)
    pipeline.sources = sources.map { |source| source.duplicate_for(user) }
    pipeline.destinations =
      destinations.map { |destination| destination.duplicate_for(user) }
    pipeline
  end

  def to_s
    name.presence || id
  end
end
