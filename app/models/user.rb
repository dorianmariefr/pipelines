class User < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_secure_password

  belongs_to :primary_email, optional: true, class_name: "Email"
  belongs_to :primary_phone_number, optional: true, class_name: "PhoneNumber"

  has_many :emails, dependent: :destroy
  has_many :phone_numbers, dependent: :destroy

  accepts_nested_attributes_for(
    :emails,
    allow_destroy: true,
    reject_if: lambda { |attributes| attributes[:email].blank? }
  )

  accepts_nested_attributes_for(
    :phone_numbers,
    allow_destroy: true,
    reject_if: lambda { |attributes| attributes[:phone_number].blank? }
  )

  validates :name, presence: true

  before_validation do
    self.primary_email = emails.first if primary_email.nil?
    self.primary_phone_number = phone_numbers.first if primary_phone_number.nil?
  end
end
