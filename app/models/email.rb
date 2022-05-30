class Email < ApplicationRecord
  REGEXP = URI::MailTo::EMAIL_REGEXP

  belongs_to :user

  validates :email, presence: true, format: { with: REGEXP }
  validates :normalized_email, uniqueness: true

  before_validation do
    self.normalized_email = EmailNormalizer.normalize(email)
  end

  before_destroy do
    user.update_columns(primary_email_id: nil) if primary?
  end

  def self.find_by_normalized_email(email_param)
    return unless email_param.present?
    email_param = EmailNormalizer.normalize(email_param)
    return unless email_param.present?
    find_by(normalized_email: email_param)
  end

  def primary?
    user.primary_email_id == id
  end
end
