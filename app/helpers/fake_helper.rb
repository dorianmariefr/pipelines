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

  def fake_user_names
    gray(eg(or_sentence((1..3).map { Faker::Name.name })))
  end

  def fake_user_emails
    gray(eg(or_sentence((1..3).map { Faker::Internet.email })))
  end

  def fake_user_passwords
    gray(eg(or_sentence((1..3).map { Faker::Internet.password })))
  end

  def fake_pipeline_name
    gray(eg(or_sentence((1..3).map { Faker::Hobby.activity })))
  end

  def subreddits
    File.read(Rails.root.join("lib", "data", "subreddits.txt")).split
  end

  def fake_subreddits
    gray(eg(or_sentence(subreddits.sample(3))))
  end

  def tags
    File.read(Rails.root.join("lib", "data", "tags.txt")).split
  end

  def fake_tags
    gray(eg(or_sentence(tags.sample(3))))
  end

  def fake_query
    gray(eg(or_sentence((1..3).map { Faker::Hobby.activity })))
  end

  def keys
    File.read(Rails.root.join("lib", "data", "keys.txt")).split
  end

  def fake_keys
    gray(eg(or_sentence(keys.sample(3))))
  end

  def fake_values
    gray(eg(or_sentence((1..3).map { Faker::Hobby.activity })))
  end

  def filters
    [
      'title.include?("Ruby")',
      'title.downcase.include?("react")',
      'keywords.include?("Bitcoin")',
      'text.include?("#ruby")',
      "retweets > 100",
      "likes > 50",
      "followers >= 1000"
    ]
  end

  def fake_filters
    gray(eg(or_sentence(filters.shuffle)))
  end

  def subjects
    [
      "{item.summary}",
      "{items.first.summary}",
      "{item.user_name}: {item.text}",
      "Summary of tweets",
      "New tweet"
    ]
  end

  def fake_subjects
    gray(eg(or_sentence(subjects.shuffle)))
  end

  def bodies
    %w[
      {item.to_text}
      {item.to_html}
      {items.first.to_text}
      {items.first.to_html}
      {pipeline.url}
    ]
  end

  def fake_bodies
    gray(eg(or_sentence(bodies.shuffle)))
  end

  def eg(string)
    t("application.fake.eg", string: string)
  end

  def gray(string)
    content_tag(:div, string, class: "text-gray-600")
  end

  def or_sentence(array)
    array.to_sentence(last_word_connector: t("application.fake.or"))
  end
end
