class Email < ApplicationRecord
  REGEXP = URI::MailTo::EMAIL_REGEXP
  VERIFICATION_CODE_LENGTH = 6
  SIGNED_ID_PURPOSE = :email_verification
  SIGNED_ID_EXPIRES_IN = 30.minutes
  CODE_REGEXP = /^(?:\s*[0-9]\s*){6}$/

  belongs_to :user

  scope :verified, -> { where(verified: true) }

  validates :email, presence: true, format: {with: REGEXP}
  validates :normalized_email, uniqueness: true

  before_validation { self.normalized_email = EmailNormalizer.normalize(email) }

  before_destroy { user.update_columns(primary_email_id: nil) if primary? }

  def self.find_by_normalized_email(email_param)
    return unless email_param.present?
    email_param = EmailNormalizer.normalize(email_param)
    return unless email_param.present?
    find_by(normalized_email: email_param)
  end

  def self.generate_verification_code
    "%0#{VERIFICATION_CODE_LENGTH}d" % rand(10**VERIFICATION_CODE_LENGTH)
  end

  def send_verification!
    update!(verification_code: self.class.generate_verification_code)
    EmailMailer.with(email: self).verification_email.deliver_later
  end

  def primary?
    user.primary_email_id == id
  end

  def not_verified?
    !verified?
  end

  def sent?
    verification_code.present?
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

  def to_s
    email
  end
end
