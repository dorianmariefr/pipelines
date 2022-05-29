class PhoneNumber < ApplicationRecord
  belongs_to :user

  validates :normalized_phone_number, presence: true, uniqueness: true, phone: true

  before_validation do
    self.normalized_phone_number = PhoneNumberNormalizer.normalize(phone_number)
  end
end
