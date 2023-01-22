class User < ApplicationRecord
  extend FriendlyId

  RESET_PASSWORD_PURPOSE = :reset_password
  RESET_PASSWORD_EXPIRES_IN = 30.minutes

  PRO_PRICE_USD = Money.from_cents(1000, "USD")
  PRO_PRICE_EUR = Money.from_cents(1000, "EUR")

  has_secure_password
  friendly_id :name, use: :slugged
  has_one_attached :avatar

  belongs_to :primary_email, optional: true, class_name: "Email"
  belongs_to :primary_phone_number, optional: true, class_name: "PhoneNumber"

  has_many :emails, dependent: :destroy
  has_many :phone_numbers, dependent: :destroy
  has_many :pipelines, dependent: :destroy

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

  scope :published,
    -> { left_joins(:pipelines).merge(Pipeline.published).distinct }

  validates :name, presence: true

  before_validation do
    self.primary_email = emails.first if primary_email.nil?
    self.primary_phone_number = phone_numbers.first if primary_phone_number.nil?
  end

  def time
    Time.now.in_time_zone(time_zone)
  end

  def hour
    time.hour
  end

  def day_of_week
    if time.monday?
      :monday
    elsif time.tuesday?
      :tuesday
    elsif time.wednesday?
      :wednesday
    elsif time.thursday?
      :thursday
    elsif time.friday?
      :friday
    elsif time.saturday?
      :saturday
    else
      :sunday
    end
  end

  def day_of_month
    time.day
  end

  def reset_password_url
    Rails.application.routes.url_helpers.edit_user_password_url(
      signed_id(
        expires_in: RESET_PASSWORD_EXPIRES_IN,
        purpose: RESET_PASSWORD_PURPOSE
      )
    )
  end

  def emails_json
    emails
      .map do |email|
        {id: email.id, email: email.email, verified: email.verified?}
      end
      .to_json
  end

  def published?
    pipelines.any?(&:published?)
  end
end
