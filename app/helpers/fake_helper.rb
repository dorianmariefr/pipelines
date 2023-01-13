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
    gray(
      eg(
        [
          Faker::Hobby.activity,
          Faker::Hobby.activity,
          Faker::Hobby.activity
        ].to_sentence(last_word_connector: t("application.fake.or"))
      )
    )
  end

  def fake_filter
    gray(
      eg(
        [
          'title.include?("Show HN")',
          'keywords.include?("Ruby")',
          "score >= 100"
        ].to_sentence(last_word_connector: t("application.fake.or"))
      )
    )
  end

  def eg(string)
    t("application.fake.eg", string: string)
  end

  def gray(string)
    content_tag(:div, string, class: "text-gray-600")
  end
end
