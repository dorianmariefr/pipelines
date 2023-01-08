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
    items = sources.map(&:fetch).flatten

    destinations.each do |destination|
      items.each { |item| destination.send_now(item) }
    end
  end

  def process_later
    items = sources.map(&:fetch).flatten

    destinations.each do |destination|
      items.each { |item| destination.send_later(item) }
    end
  end

  def to_s
    name.presence || id
  end
end
