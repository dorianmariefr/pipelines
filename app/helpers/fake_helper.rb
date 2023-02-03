module FakeHelper
  def fake_emails
    gray(eg(or_sentence((1..3).map { Faker::Internet.email })))
  end

  def fake_phone_numbers
    gray(
      eg(
        or_sentence(
          (1..3).map { Faker::PhoneNumber.cell_phone_with_country_code }
        )
      )
    )
  end

  def fake_passwords
    gray(eg(or_sentence((1..3).map { Faker::Internet.password })))
  end

  def fake_codes
    gray(eg(or_sentence((1..3).map { Email.generate_verification_code })))
  end

  def fake_user_names
    gray(eg(or_sentence((1..3).map { Faker::Name.name })))
  end

  def fake_pipeline_names
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

  def fake_time_zones
    gray(eg(or_sentence(ActiveSupport::TimeZone.all.map(&:name).sample(3))))
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
