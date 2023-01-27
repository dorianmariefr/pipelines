module FakeHelper
  def fake_name
    gray(eg(Faker::Name.name))
  end

  def fake_email
    gray(eg(Faker::Internet.email))
  end

  def fake_phone_number
    gray(eg(Faker::PhoneNumber.cell_phone_with_country_code))
  end

  def fake_password
    gray(eg(Faker::Internet.password))
  end

  def fake_code
    gray(eg(Email.generate_verification_code))
  end

  def fake_pipeline_name
    [
      Faker::Hobby.activity,
      Faker::Hobby.activity,
      Faker::Hobby.activity
    ].to_sentence(last_word_connector: t("application.fake.or"))
  end

  def fake_subreddits
    File
      .read(Rails.root.join("lib", "data", "subreddits.txt"))
      .split
      .sample(10)
      .to_sentence(last_word_connector: t("application.fake.or"))
  end

  def fake_tags
    File
      .read(Rails.root.join("lib", "data", "tags.txt"))
      .split
      .sample(10)
      .to_sentence(last_word_connector: t("application.fake.or"))
  end

  def fake_result_types
    %w[mixed popular recent].shuffle.to_sentence(
      last_word_connector: t("application.fake.or")
    )
  end

  def fake_query
    (1..10)
      .map { Faker::Hobby.activity }
      .to_sentence(last_word_connector: t("application.fake.or"))
  end

  def fake_limits
    [1, 5, 10, 20].to_sentence(last_word_connector: t("application.fake.or"))
  end

  def fake_filter_types
    Source::FILTER_TYPES.shuffle.to_sentence(
      last_word_connector: t("application.fake.or")
    )
  end

  def fake_keys
    File
      .read(Rails.root.join("lib", "data", "keys.txt"))
      .split
      .sample(10)
      .to_sentence(last_word_connector: t("application.fake.or"))
  end

  def fake_operators
    Source::OPERATORS.shuffle.to_sentence(
      last_word_connector: t("application.fake.or")
    )
  end

  def fake_transforms
    Source::TRANSFORMS.shuffle.to_sentence(
      last_word_connector: t("application.fake.or")
    )
  end

  def fake_values
    [
      1000,
      20,
      Faker::Hobby.activity,
      Faker::Hobby.activity,
      Faker::Hobby.activity
    ].shuffle.to_sentence(last_word_connector: t("application.fake.or"))
  end

  def fake_filters
    [
      'title.include?("Ruby")',
      'title.downcase.include?("react")',
      'keywords.include?("Bitcoin")',
      'text.include?("#ruby")',
      "retweets > 100",
      "likes > 50",
      "followers >= 1000"
    ].shuffle.to_sentence(last_word_connector: t("application.fake.or"))
  end

  def fake_subjects
    [
      "{item.summary}",
      "{items.first.summary}",
      "{item.user_name}: {item.text}",
      "Summary of tweets",
      "New tweet"
    ].shuffle.to_sentence(last_word_connector: t("application.fake.or"))
  end

  def fake_body_formats
    %w[text html].shuffle.join(t("application.fake.or"))
  end

  def fake_bodies
    %w[
      {item.to_text}
      {item.to_html}
      {items.first.to_text}
      {items.first.to_html}
    ].shuffle.to_sentence(last_word_connector: t("application.fake.or"))
  end

  def fake_hours
    (0..23)
      .map { |hour| "#{hour}:00" }
      .sample(3)
      .to_sentence(last_word_connector: t("application.fake.or"))
  end

  def fake_days_of_week
    Date::DAYNAMES.shuffle.to_sentence(
      last_word_connector: t("application.fake.or")
    )
  end

  def fake_days_of_month
    (1..31)
      .to_a
      .sample(5)
      .to_sentence(last_word_connector: t("application.fake.or"))
  end

  def pipeline_fakes
    {
      transform: fake_transforms,
      name: fake_pipeline_name,
      subreddit: fake_subreddits,
      tagged: fake_tags,
      result_type: fake_result_types,
      query: fake_query,
      limit: fake_limits,
      filter_type: fake_filter_types,
      key: fake_keys,
      operator: fake_operators,
      value: fake_values,
      filter: fake_filters,
      subject: fake_subjects,
      body_format: fake_body_formats,
      body: fake_bodies,
      hour: fake_hours,
      day_of_week: fake_days_of_week,
      day_of_month: fake_days_of_month
    }
  end

  def eg(string)
    t("application.fake.eg", string: string)
  end

  def gray(string)
    content_tag(:div, string, class: "text-gray-600")
  end
end
