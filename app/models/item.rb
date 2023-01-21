class Item < ApplicationRecord
  KINDS = {
    reddit: {
      new: "Item::Reddit::New"
    },
    stack_exchange: {
      questions: "Item::StackExchange::Questions"
    },
    hacker_news: {
      news: "Item::HackerNews::News",
      newest: "Item::HackerNews::Newest"
    },
    twitter: {
      search: "Item::Twitter::Search"
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
    KINDS.dig(first_kind, second_kind).constantize.new(self)
  end

  def as_json(...)
    {external_id: external_id, pipeline: pipeline.as_json, **extras}.as_json(
      ...
    ).with_indifferent_access
  end
end
