class PhoneNumber < ApplicationRecord
  VERIFICATION_CODE_LENGTH = 6
  SIGNED_ID_PURPOSE = :phone_number_verification
  SIGNED_ID_EXPIRES_IN = 30.minutes

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

  def self.generate_verification_code
    "%0#{VERIFICATION_CODE_LENGTH}d" % rand(10**VERIFICATION_CODE_LENGTH)
  end

  def send_verification!
    update!(verification_code: self.class.generate_verification_code)
    PhoneNumber::SendVerificationJob.perform_later(phone_number: self)
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

  def verification_code_left
    verification_code[0...(VERIFICATION_CODE_LENGTH / 2)]
  end

  def verification_code_right
    verification_code[(VERIFICATION_CODE_LENGTH / 2)..]
  end

  def verification_code_formatted
    "#{verification_code_left} #{verification_code_right}"
  end

  def verification_signed_id
    signed_id(
      expires_in: Email::SIGNED_ID_EXPIRES_IN,
      purpose: Email::SIGNED_ID_PURPOSE
    )
  end

  def verify(code)
    code = code.gsub(/\s/, "")

    if verification_code.present? && code.present? && code == verification_code
      update!(verified: true, verification_code: nil)
    else
      false
    end
  end
end
