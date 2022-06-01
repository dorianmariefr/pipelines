FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    password { Faker::Internet.password }
  end

  factory :email do
    user
    email { Faker::Internet.email }
    verified { true }
    verification_code { Email.generate_verification_code }
  end

  factory :phone_number do
    user
    phone_number { Faker::PhoneNumber.cell_phone_with_country_code }
    verified { true }
    verification_code { Phone.generate_verification_code }
  end
end
