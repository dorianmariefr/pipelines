class Source < ApplicationRecord
  KINDS = {
    hacker_news: {
      news: {
        subclass: "Source::HackerNews::News"
      },
      newest: {
        subclass: "Source::HackerNews::Newest"
      }
    }
  }

  belongs_to :pipeline

  has_many :parameters, as: :parameterizable, dependent: :destroy
  has_many :items, dependent: :destroy

  accepts_nested_attributes_for :parameters

  def self.kinds_options
    KINDS.flat_map do |first_kind, first_kind_value|
      first_kind_value.map do |second_kind, _|
        [
          I18n.t("sources.model.kinds.#{first_kind}.#{second_kind}"),
          "#{first_kind}/#{second_kind}"
        ]
      end
    end
  end

  def parameters_attributes=(*args)
    self.parameters = []
    super(*args)
  end

  def first_kind
    kind.split("/").first.to_sym
  end

  def second_kind
    kind.split("/").second.to_sym
  end

  def name
    I18n.t("sources.model.kinds.#{first_kind}.#{second_kind}")
  end

  def subclass
    KINDS.dig(first_kind, second_kind, :subclass).constantize.new(self)
  end

  def fetch
    subclass
      .fetch
      .map do |item|
        items.build(external_id: item.external_id, extras: item.extras)
      end
      .select { |item| item.match(filter) }
      .select(&:save)
  end
end
