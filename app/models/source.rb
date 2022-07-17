class Source < ApplicationRecord
  KINDS = {
    hacker_news: {
      stories: {
        name: "Hacker News - Stories"
      },
      comments: {
        name: "Hacker News - Comments"
      }
    },
    reddit: {
      posts: {
        name: "Reddit - Posts"
      },
      comments: {
        name: "Reddit - Comments"
      }
    },
    twitter: {
      tweets: {
        name: "Twitter - Tweets"
      }
    },
    lobsters: {
      stories: {
        name: "Lobsters - Stories"
      },
      comments: {
        name: "Lobsters - Comments"
      }
    }
  }

  belongs_to :pipeline

  has_many :parameters, as: :parameterable

  def self.kinds_options
    KINDS.flat_map do |parent_key, parent_value|
      parent_value.map do |key, value|
        [value.fetch(:name), "#{parent_key}/#{key}"]
      end
    end
  end

  def first_kind
    kind.split("/").first.to_sym
  end

  def second_kind
    kind.split("/").second.to_sym
  end

  def name
    KINDS.dig(first_kind, second_kind, :name)
  end
end