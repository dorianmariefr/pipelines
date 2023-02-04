class Item < ApplicationRecord
  belongs_to :source
  belongs_to :pipeline

  validates :external_id, uniqueness: {scope: :pipeline_id}

  delegate :first_kind, :second_kind, to: :source

  before_validation { self.pipeline_id = source&.pipeline_id }

  def match(filter)
    return true if filter.blank?
    Code.evaluate(filter, ruby: as_json).truthy?
  end

  def duplicate_for(user)
    Item.new(external_id: external_id, extras: extras)
  end

  def to_text
    ApplicationController.render(
      partial: "items/#{first_kind}/#{second_kind}",
      formats: [:text],
      locals: {
        item: to_struct
      }
    )
  end

  def to_html
    ApplicationController.render(
      partial: "items/#{first_kind}/#{second_kind}",
      formats: [:html],
      locals: {
        item: to_struct
      }
    )
  end

  def to_struct
    Struct.new(*extras.symbolize_keys.keys).new(*extras.values)
  end

  def rss_title
    summary
  end

  def rss_description
    to_html
  end

  def rss_pub_date
    created_at.to_formatted_s(:rfc822)
  end

  def rss_link
    url
  end

  def rss_guid
    id
  end

  def summary
    to_struct.summary
  end

  def url
    to_struct.url
  end

  def as_json(...)
    {
      **extras,
      external_id: external_id,
      pipeline: pipeline.as_json(...),
      to_text: to_text,
      to_html: to_html
    }.as_json(...)
  end
end
