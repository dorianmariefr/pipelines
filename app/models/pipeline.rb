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

  before_save do
    sources.each do |source|
      source.parameters = [] if source.as_json[:parameters].nil?
    end
  end

  def process_now
    source_results = sources.map(&:fetch)
    destination_results = []

    destinations.each do |destination|
      source_results.each do |source_result|
        destination_results << destination.send_now(source_result.saved_items)
      end
    end

    Pipeline::Result.new(
      source_results: source_results,
      destination_results: destination_results
    )
  end

  def process_later
    source_results = sources.map(&:fetch)

    destinations.instant.each do |destination|
      source_results.each do |source_result|
        destination.send_later(source_result.saved_items)
      end
    end
  end

  def duplicate_for(user)
    pipeline = Pipeline.new(name: name, published: false, user: user)
    pipeline.sources = sources.map { |source| source.duplicate_for(user) }
    pipeline.destinations =
      destinations.map { |destination| destination.duplicate_for(user) }
    pipeline
  end

  def as_json
    {
      id: id,
      slug: slug,
      name: name,
      url: Rails.application.routes.url_helpers.pipeline_path(self)
    }
  end

  def to_s
    name.presence || id
  end
end
