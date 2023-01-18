class Source < ApplicationRecord
  KINDS = {
    twitter: {
      search: "Source::Twitter::Search"
    },
    hacker_news: {
      news: "Source::HackerNews::News",
      newest: "Source::HackerNews::Newest"
    }
  }

  belongs_to :pipeline

  has_many :parameters, as: :parameterizable, dependent: :destroy
  has_many :items, dependent: :destroy

  accepts_nested_attributes_for :parameters

  delegate :as_json, to: :subclass

  def self.each_kind(&block)
    KINDS.flat_map do |first_kind, first_kind_value|
      first_kind_value.map do |second_kind, second_kind_value|
        block.call(first_kind, second_kind, second_kind_value)
      end
    end
  end

  def self.kinds_options
    each_kind do |first, second|
      [I18n.t("sources.model.kinds.#{first}.#{second}"), "#{first}/#{second}"]
    end
  end

  def self.as_json(...)
    each_kind do |first, second, subclass|
      ["#{first}/#{second}", subclass.constantize.as_json]
    end.to_h
  end

  def self.email_subject_defaults
    each_kind do |first, second, subclass|
      ["#{first}/#{second}", subclass.constantize.email_subject_default]
    end.to_h
  end

  def self.email_body_defaults
    each_kind do |first, second, subclass|
      ["#{first}/#{second}", subclass.constantize.email_body_default]
    end.to_h
  end

  def self.email_digest_subject_defaults
    each_kind do |first, second, subclass|
      ["#{first}/#{second}", subclass.constantize.email_digest_subject_default]
    end.to_h
  end

  def self.email_digest_body_defaults
    each_kind do |first, second, subclass|
      ["#{first}/#{second}", subclass.constantize.email_digest_body_default]
    end.to_h
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

  def duplicate_for(user)
    source = Source.new(kind: kind, filter: filter)
    source.items = items.map { |item| item.duplicate_for(user) }
    source
  end

  def name
    I18n.t("sources.model.kinds.#{first_kind}.#{second_kind}")
  end

  def subclass
    KINDS.dig(first_kind, second_kind).constantize.new(self)
  end

  def params
    parameters
      .map { |parameter| [parameter.key, parameter.value] }
      .to_h
      .with_indifferent_access
  end

  def fetch
    result = Source::Result.new
    result.new_items =
      subclass.fetch.map do |item|
        items.build(external_id: item.external_id, extras: item.extras)
      end
    result.matched_items = result.new_items.select { |item| item.match(filter) }
    result.saved_items = result.matched_items.select(&:save)
  rescue => e
    update!(
      error: "#{e.class}: #{e.message}",
      backtrace: e.backtrace.grep(/#{Rails.root}/).join("\n")
    )
    Source::Result.new(error: e.message)
  else
    update!(error: nil, backtrace: nil)
    result
  end
end
