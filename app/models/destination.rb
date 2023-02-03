class Destination < ApplicationRecord
  KINDS = {
    hourly_email_digest: "Destination::HourlyEmailDigest",
    daily_email_digest: "Destination::DailyEmailDigest",
    weekly_email_digest: "Destination::WeeklyEmailDigest",
    monthly_email_digest: "Destination::MonthlyEmailDigest",
    email: "Destination::Email"
  }

  belongs_to :pipeline
  has_one :user, through: :pipeline
  has_many :sources, through: :pipeline
  has_many :items, through: :sources

  has_many :parameters, as: :parameterizable, dependent: :destroy

  accepts_nested_attributes_for :parameters

  scope :hourly_email_digest, -> { where(kind: :hourly_email_digest) }
  scope :daily_email_digest, -> { where(kind: :daily_email_digest) }
  scope :weekly_email_digest, -> { where(kind: :weekly_email_digest) }
  scope :monthly_email_digest, -> { where(kind: :monthly_email_digest) }
  scope :email, -> { where(kind: :email) }
  scope :instant, -> { email }

  def parameters_attributes=(...)
    self.parameters = []
    super(...)
  end

  def name
    I18n.t("destinations.model.kinds.#{kind}")
  end

  def subclass
    KINDS.dig(kind.to_sym).constantize.new(self)
  end

  def send_now(items = [])
    subclass.send_now(items)
    Destination::Result.new(sent_items: items.presence || subclass.items)
  end

  def send_later(items = [])
    SendToDestinationJob.perform_later(destination: self, items: items)
    Destination::Result.new(sent_items: items.presence || subclass.items)
  end

  def params
    parameters
      .map { |parameter| [parameter.key, parameter.value] }
      .to_h
      .with_indifferent_access
  end

  def duplicate_for(user)
    destination = Destination.new(kind: kind)
    destination.parameters =
      parameters.map { |parameter| parameter.duplicate_for(user) }
    destination
  end

  def as_json(...)
    {id: id, kind: kind, parameters: parameters.as_json(...)}.as_json(...)
  end
end
