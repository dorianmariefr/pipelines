class Source < ApplicationRecord
  KINDS = {
    hacker_news: {
      news: {
        name: "Hacker News - Stories",
        subclass: "Source::HackerNews::News"
      },
      new: {
        name: "Hacker News - New Stories",
        subclass: "Source::HackerNews::New"
      }
    }
  }

  belongs_to :pipeline

  has_many :parameters, as: :parameterizable, dependent: :destroy
  has_many :items, dependent: :destroy

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

  def subclass
    KINDS.dig(first_kind, second_kind, :subclass).constantize
  end

  def fetch
    new_items = subclass.fetch

    new_items.delete_if do |item|
      items.where(external_id: item.external_id).any?
    end

    new_items =
      new_items.map do |item|
        items.build(
          subject: item.subject,
          body: item.body,
          external_id: item.external_id
        )
      end

    new_items.select { |item| item.match(filter) }
  end
end
