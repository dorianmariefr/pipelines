module ApplicationHelper
  def title
    return unless action_name
    action = action_name.to_sym
    action = :new if action == :create
    action = :edit if action == :update

    if content_for?(:title)
      content_for(:title)
    else
      t("#{controller_path.tr("/", ".")}.#{action}.title")
    end
  end

  def en?
    I18n.locale == :en
  end

  def fr?
    I18n.locale == :fr
  end

  def email_regexp
    json_regexp(Email::REGEXP)
  end

  def code_regexp
    json_regexp(Email::CODE_REGEXP)
  end

  def initial_country
    en? ? "US" : "FR"
  end

  def json_regexp(regexp)
    str =
      regexp
        .inspect
        .sub('\A', "^")
        .sub('\Z', "$")
        .sub('\z', "$")
        .sub(%r{^/}, "")
        .sub(%r{/[a-z]*$}, "")
        .gsub(/\(\?#.+\)/, "")
        .gsub(/\(\?-\w+:/, "(")
        .gsub(/\s/, "")

    Regexp.new(str).source
  end

  def hobby_price
    fr? ? User::HOBBY_PRICE_EUR : User::HOBBY_PRICE_USD
  end

  def pro_price
    fr? ? User::PRO_PRICE_EUR : User::PRO_PRICE_USD
  end

  def custom_price
    fr? ? User::CUSTOM_PRICE_EUR : User::CUSTOM_PRICE_USD
  end

  def admin?
    current_user&.admin?
  end

  def source_kind_options
    Source::KINDS
      .flat_map do |first_kind, first_value|
        first_value.map do |second_kind, _|
          [
            t("sources.model.kinds.#{first_kind}.#{second_kind}"),
            "#{first_kind}/#{second_kind}"
          ]
        end
      end
  end

  def destination_kind_options
    Destination::KINDS.map do |kind, _|
      [t("destinations.model.kinds.#{kind}"), kind]
    end
  end

  def filter_type_options
    Source::FILTER_TYPES.map do |filter_type|
      [t("sources.model.filter_types.#{filter_type}"), filter_type]
    end
  end

  def source_key_options(subclass)
    subclass.keys.map { |key| [key, key] }
  end

  def source_transform_options
    Source::TRANSFORMS.map do |transform|
      [t("sources.model.transforms.#{transform}"), transform]
    end
  end

  def source_operator_options
    Source::OPERATORS.map do |operator|
      [t("sources.model.operators.#{operator}"), operator]
    end
  end
end
