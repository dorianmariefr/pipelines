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

  def primary_button_link_to(text_or_href, href = nil, **options, &block)
    text = block ? capture(&block) : text_or_href
    href = text_or_href if href.nil?
    content_tag(
      :a,
      text,
      href: href,
      class:
        "inline-flex items-center gap-2 rounded-lg text-white " \
          "bg-green-600 hover:bg-green-700 focus:bg-green-800 #{options[:class]}"
    )
  end

  def button_link_to(text_or_href, href = nil, **options, &block)
    text = block ? capture(&block) : text_or_href
    href = text_or_href if href.nil?
    content_tag(
      :a,
      text,
      href: href,
      class:
        "inline-flex items-center gap-2 rounded-lg h-fit " \
          "bg-gray-100 hover:bg-gray-200 focus:bg-gray-300 #{options[:class]}"
    )
  end
end
