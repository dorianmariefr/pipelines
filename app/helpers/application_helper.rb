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

  def mastodon_identifier_regexp
    json_regexp(Account::MASTODON_IDENTIFIER_REGEXP)
  end

  def twitter_identifier_regexp
    json_regexp(Account::TWITTER_IDENTIFIER_REGEXP)
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
    Source::KINDS.flat_map do |first_kind, first_value|
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

  def account_kind_options
    Account::KINDS.map { |kind, _| [t("accounts.model.kinds.#{kind}"), kind] }
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

  def time_zone_options
    ActiveSupport::TimeZone
      .all
      .sort_by(&:name)
      .map { |time_zone| [time_zone.name, time_zone.name] }
  end

  def mastodon_account_scope_options
    Account::MASTODON_SCOPES.map { |scope| [scope, scope] }
  end

  def twitter_account_scope_options
    Account::TWITTER_SCOPES.map { |scope| [scope, scope] }
  end

  def twitter_format(item, **options)
    text = item.retweeted_status&.full_text || item.full_text

    item.entities.urls.each { |url| text.gsub!(url.url, url.expanded_url) }

    item.entities.user_mentions.each do |mention|
      text.gsub!(/@#{mention.screen_name}( |$)/) do
        match = Regexp.last_match

        safe_join(
          [
            content_tag(
              :a,
              "@#{mention.screen_name}",
              href: "https://twitter.com/#{mention.screen_name}"
            ),
            match[1]
          ]
        )
      end
    end

    item.entities.hashtags.each do |hashtag|
      text.gsub!(/##{hashtag.text}( |$)/) do
        match = Regexp.last_match

        safe_join(
          [
            content_tag(
              :a,
              "##{hashtag.text}",
              href: "https://twitter.com/hashtag/#{hashtag.text}"
            ),
            match[1]
          ]
        )
      end
    end

    item.entities.media&.each do |media|
      text.gsub!(media.url, content_tag(:p, image_tag(media.media_url_https)))
    end

    text = simple_format(text)
    auto_link(
      text,
      html: options,
      sanitize_options: {
        tags: %w[a p img],
        attributes: %w[href style src]
      }
    )
  end
end
