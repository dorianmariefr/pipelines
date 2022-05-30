class Email < ApplicationRecord
  REGEXP = URI::MailTo::EMAIL_REGEXP

  belongs_to :user

  validates :email, presence: true
  validates :normalized_email, presence: true, uniqueness: true, format: { with: REGEXP }

  before_validation do
    self.normalized_email = EmailNormalizer.normalize(email)
  end
end
