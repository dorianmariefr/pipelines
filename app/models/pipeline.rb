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
    source_results = sources.map(&:fetch)
    destination_results = []

    Pipeline.transaction do
      destinations.each do |destination|
        source_results.each do |source_result|
          if source_result.saved_items.any?
            destination_results << destination.send_now(
              source_result.saved_items
            )
          end
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
    source_results = sources.map(&:fetch)

    Pipeline.transaction do
      destinations.instant.each do |destination|
        source_results.each do |source_result|
          if source_result.saved_items.any?
            destination.send_later(source_result.saved_items)
          end
        end
      end

      update!(error: nil)
    end
  rescue => e
    update!(error: "#{e.class}: #{e.message}")
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
      name: name,
      url: Rails.application.routes.url_helpers.pipeline_url(self)
    }
  end
end
