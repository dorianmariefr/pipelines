class Source < ApplicationRecord
  KINDS = {
    hacker_news: {
      front: {
        name: "Hacker News - Frontpage Stories"
      },
      new: {
        name: "Hacker News - New Stories"
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
