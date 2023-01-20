module ApplicationHelper
  def title
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

  def pro_price
    fr? ? User::PRO_PRICE_EUR : User::PRO_PRICE_USD
  end

  def source_kinds_options(source)
    options_for_select(Source.kinds_options, source.kind)
  end

  def source_filter_types_options(source)
    options_for_select(Source.filter_types_options, source.filter_type)
  end

  def source_operators_options(source)
    options_for_select(Source.operators_options, source.operator)
  end

  def destination_kinds_options(destination)
    options_for_select(Destination.kinds_options, destination.kind)
  end

  def admin?
    current_user&.admin?
  end
end
