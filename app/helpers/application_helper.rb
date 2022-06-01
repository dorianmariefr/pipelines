module ApplicationHelper
  def title
    action = action_name.to_sym
    action = :new if action == :create
    action = :edit if action == :update
    if content_for?(:title)
      content_for(:title)
    else
      t("#{controller_name}.#{action}.title")
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
end
