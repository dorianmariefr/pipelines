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

  def eg(string)
    t("application.fake.eg", string: string)
  end

  def gray(string)
    content_tag(:div, string, class: "text-gray-500")
  end
end
