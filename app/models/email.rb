class Email < ApplicationRecord
  REGEXP = URI::MailTo::EMAIL_REGEXP

  belongs_to :user

  validates :email, presence: true, uniqueness: true, format: { with: REGEXP }

  before_validation do
    self.email = EmailNormalizer.format(email)
  end
end
