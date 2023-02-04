class Pipeline < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :sequentially_slugged

  belongs_to :user

  has_many :sources, dependent: :destroy
  has_many :destinations, dependent: :destroy
  has_many :items, through: :sources

  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :sources, allow_destroy: true
  accepts_nested_attributes_for :destinations, allow_destroy: true

  scope :published, -> { where(published: true) }

  def process_now
    source_results = []
    destination_results = []

    ApplicationRecord.transaction do
      source_results = sources.map(&:fetch)
      saved_items = source_results.map(&:saved_items).flatten

      if saved_items.any?
        destinations.each do |destination|
          destination_results << destination.send_now(saved_items)
        end
      end

      update!(error: nil)
    end
  rescue => e
    update!(
      error: "#{e.class}: #{e.message}",
      backtrace: e.backtrace.grep(/#{Rails.root}/).join("\n")
    )
    Pipeline::Result.new(error: error)
  else
    Pipeline::Result.new(
      source_results: source_results,
      destination_results: destination_results
    )
  end

  def process_later
    ApplicationRecord.transaction do
      source_results = sources.map(&:fetch)
      saved_items = source_results.map(&:saved_items).flatten

      if saved_items.any?
        destinations.instant.each do |destination|
          destination_results << destination.send_now(saved_items)
        end
      end

      update!(error: nil)
    end
  rescue => e
    update!(error: "#{e.class}: #{e.message}")
  end

  def duplicate_for(user)
    pipeline = Pipeline.new(name: name, published: published?, user: user)
    pipeline.sources = sources.map { |source| source.duplicate_for(user) }
    pipeline.destinations =
      destinations.map { |destination| destination.duplicate_for(user) }
    pipeline
  end

  def as_json
    {
      id: id,
      name: name,
      url: Rails.application.routes.url_helpers.pipeline_url(self)
    }
  end
end
