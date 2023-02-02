class PhoneNumber < ApplicationRecord
  VERIFICATION_CODE_LENGTH = 6
  SIGNED_ID_PURPOSE = :phone_number_verification
  SIGNED_ID_EXPIRES_IN = 30.minutes

  belongs_to :user

  scope :verified, -> { where(verified: true) }

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

  def send_verification!
    result = sms.send_code
    update!(external_token: result.id)
  end

  def phonelib
    Phonelib.parse(phone_number)
  end

  def e164
    phonelib.e164
  end

  def formatted_phone_number
    phonelib.international
  end

  def primary?
    user.primary_phone_number_id == id
  end

  def not_verified?
    !verified?
  end

  def sms
    Sms.new(self)
  end

  def sent?
    external_token.present?
  end

  def verify(code)
    code = code.gsub(/\s/, "")

    if external_token.present? && code.present?
      sms.verify_code(code)
      update!(verified: true, external_token: nil)
    else
      false
    end
  rescue MessageBird::ErrorException
    false
  end
end
