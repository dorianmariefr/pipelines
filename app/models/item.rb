class Item < ApplicationRecord
  KINDS = {
    hacker_news: {
      news: {
        subclass: "Item::HackerNews::News"
      },
      newest: {
        subclass: "Item::HackerNews::Newest"
      }
    },
    twitter: {
      search: {
        subclass: "Item::Twitter::Search"
      }
    }
  }

  belongs_to :source
  has_one :pipeline, through: :source

  validates :external_id, uniqueness: {scope: :source_id}

  delegate :first_kind, :second_kind, to: :source
  delegate :urls,
    :url,
    :to_s,
    :rss_title,
    :rss_description,
    :rss_pub_date,
    :rss_link,
    :rss_guid,
    to: :subclass

  def match(filter)
    return true if filter.blank?
    Code.evaluate(filter, ruby: as_json).truthy?
  end

  def duplicate_for(user)
    Item.new(external_id: external_id, extras: extras)
  end

  def subclass
    KINDS.dig(first_kind, second_kind, :subclass).constantize.new(self)
  end

  def as_json(...)
    {external_id: external_id, pipeline: pipeline.as_json, **extras}.as_json(
      ...
    ).with_indifferent_access
  end
end
