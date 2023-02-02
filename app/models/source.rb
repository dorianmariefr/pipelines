class Source < ApplicationRecord
  KINDS = {
    reddit: {
      new: "Source::Reddit::New"
    },
    stack_exchange: {
      questions: "Source::StackExchange::Questions"
    },
    twitter: {
      search: "Source::Twitter::Search"
    },
    hacker_news: {
      news: "Source::HackerNews::News",
      newest: "Source::HackerNews::Newest"
    }
  }

  NONE = "none"
  SIMPLE = "simple"
  CODE = "code"
  INCLUDES = "includes"
  EQUALS = "equals"
  GREATER_THAN = "greater_than"
  GREATER_THAN_OR_EQUALS = "greater_than_or_equals"
  LESS_THAN = "less_than"
  LESS_THAN_OR_EQUALS = "less_than_or_equals"
  DOWNCASE = "downcase"

  FILTER_TYPES = [NONE, SIMPLE, CODE]
  OPERATORS = [
    INCLUDES,
    EQUALS,
    GREATER_THAN,
    GREATER_THAN_OR_EQUALS,
    LESS_THAN,
    LESS_THAN_OR_EQUALS
  ]
  TRANSFORMS = [NONE, DOWNCASE]

  belongs_to :pipeline

  has_many :parameters, as: :parameterizable, dependent: :destroy
  has_many :items, dependent: :destroy

  accepts_nested_attributes_for :parameters

  delegate :as_json, to: :subclass

  def parameters_attributes=(...)
    self.parameters = []
    super(...)
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

  def translated_operator
    I18n.t("sources.model.operators.#{operator}")
  end

  def none?
    filter_type == NONE
  end

  def simple?
    filter_type == SIMPLE
  end

  def code?
    filter_type == CODE
  end

  def includes?
    operator == INCLUDES
  end

  def equals?
    operator == EQUALS
  end

  def greater_than?
    operator == GREATER_THAN
  end

  def greater_than_or_equals?
    operator == GREATER_THAN_OR_EQUALS
  end

  def less_than?
    operator == LESS_THAN
  end

  def less_than_or_equals?
    operator == LESS_THAN_OR_EQUALS
  end

  def simple_filter
    return if key.blank? || operator.blank? || value.blank?

    "#{key} #{translated_operator} #{value}"
  end

  def match(item)
    if none?
      true
    elsif code?
      filter.present? ? item.match(filter) : true
    elsif simple_filter.present?
      v = item.as_json[key].to_s
      v = v.downcase if transform == DOWNCASE
      if includes?
        v.to_s.include?(value.to_s)
      elsif equals?
        v.to_s == value.to_s
      elsif greater_than?
        v.to_f > value.to_f
      elsif greater_than_or_equals?
        v.to_f >= value.to_f
      elsif less_than?
        v.to_f < value.to_f
      elsif less_than_or_equals?
        v.to_f <= value.to_f
      else
        raise NotImplementedError
      end
    else
      true
    end
  end

  def fetch
    result = Source::Result.new
    result.new_items =
      subclass.fetch.map do |item|
        Item.new(
          source: self,
          external_id: item.external_id,
          extras: item.extras
        )
      end
    result.matched_items = result.new_items.select { |item| match(item) }
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
