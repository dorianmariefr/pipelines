class Destination < ApplicationRecord
  KINDS = {
    email: "Destination::Email",
    hourly_email_digest: "Destination::DailyEmailDigest",
    daily_email_digest: "Destination::DailyEmailDigest",
    weekly_email_digest: "Destination::WeeklyEmailDigest",
    monthly_email_digest: "Destination::MonthlyEmailDigest"
  }

  belongs_to :pipeline
  belongs_to :destinable, polymorphic: true
  has_one :user, through: :pipeline
  has_many :sources, through: :pipeline
  has_many :items, through: :sources

  has_many :parameters, as: :parameterizable, dependent: :destroy

  accepts_nested_attributes_for :parameters

  scope :email, -> { where(kind: :email) }
  scope :hourly_email_digest, -> { where(kind: :hourly_email_digest) }
  scope :daily_email_digest, -> { where(kind: :daily_email_digest) }
  scope :weekly_email_digest, -> { where(kind: :weekly_email_digest) }
  scope :monthly_email_digest, -> { where(kind: :monthly_email_digest) }
  scope :instant, -> { email }

  validates :destinable_type, inclusion: { in: ["Email"] }
  validates :destinable, presence: true
  validate :verified_destinable
  validate :own_destinable

  def self.kinds_options
    KINDS.map { |kind, _| [I18n.t("destinations.model.kinds.#{kind}"), kind] }
  end

  def self.as_json(...)
    KINDS.map { |kind, subclass| [kind, subclass.constantize.as_json] }.to_h
  end

  def parameters_attributes=(*args)
    self.parameters = []
    super(*args)
  end

  def name
    I18n.t("destinations.model.kinds.#{kind}")
  end

  def subclass
    KINDS.dig(kind.to_sym).constantize.new(self)
  end

  def send_now(items = nil)
    subclass.send_now(items)
  rescue => e
    update!(
      error: "#{e.class}: #{e.message}",
      backtrace: e.backtrace.grep(/#{Rails.root}/).join("\n")
    )
    Destination::Result.new(error: e.message)
  else
    update!(error: nil, backtrace: nil)
    Destination::Result.new(sent_items: items || subclass.items)
  end

  def send_later(items = nil)
    SendToDestinationJob.perform_later(destination: self, items: items)
    Destination::Result.new(sent_items: items || subclass.items)
  end

  def to
    destinable.email
  end

  def params
    parameters
      .map { |parameter| [parameter.key, parameter.value] }
      .to_h
      .with_indifferent_access
  end

  def duplicate_for(user)
    if destinable_type == "Email"
      destinable = user.emails.verified.first
      destination = Destination.new(destinable: destinable, kind: kind)
      destination.parameters =
        parameters.map { |parameter| parameter.duplicate_for(user) }
      destination
    else
      raise NotImplementedError
    end
  end

  private

  def own_destinable
    if destinable && destinable.user != pipeline.user
      errors.add(:destinable, I18n.t("errors.not_own"))
    end
  end

  def verified_destinable
    if destinable && !destinable.verified?
      errors.add(:destinable, I18n.t("errors.not_verified"))
    end
  end
end
