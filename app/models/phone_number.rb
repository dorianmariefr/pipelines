class PhoneNumber < ApplicationRecord
  belongs_to :user

  validates :phone_number, presence: true, phone: true
  validates :normalized_phone_number, uniqueness: true

  before_validation do
    self.normalized_phone_number = PhoneNumberNormalizer.normalize(phone_number)
  end

  before_destroy do
    user.update_columns(primary_phone_number_id: nil) if primary?
  end

  def self.find_by_normalized_phone_number(phone_number_param)
    return unless phone_number_param.present?
    phone_number_param = PhoneNumberNormalizer.normalize(phone_number_param)
    return unless phone_number_param.present?
    find_by(normalized_phone_number: phone_number_param)
  end

  def primary?
    user.primary_phone_number_id == id
  end

  def not_verified?
    !verified?
  end
end
