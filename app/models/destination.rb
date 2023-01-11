class Destination < ApplicationRecord
  KINDS = {
    email: {
      name: "Email",
      subclass: "Destination::Email",
      instant: true,
      destinable_type: :Email,
      destinable_label: :email
    },
    hourly_email_digest: {
      name: "Hourly Email Digest",
      subclass: "Destination::HourlyEmailDigest",
      instant: false,
      destinable_type: :Email,
      destinable_label: :email
    },
    daily_email_digest: {
      name: "Daily Email Digest",
      subclass: "Destination::DailyEmailDigest",
      instant: false,
      destinable_type: :Email,
      destinable_label: :email,
      parameters: {
        hour: {
          default: "18",
          translate: false,
          kind: :select,
          options: Parameter::HOURS
        }
      }
    },
    weekly_email_digest: {
      name: "Weekly Email Digest",
      subclass: "Destination::WeeklyEmailDigest",
      instant: false,
      destinable_type: :Email,
      destinable_label: :email,
      parameters: {
        hour: {
          default: "18",
          translate: false,
          kind: :select,
          options: Parameter::HOURS
        },
        day_of_week: {
          default: :thursday,
          translate: true,
          kind: :select,
          options: Parameter::DAYS_OF_WEEK
        }
      }
    },
    monthly_email_digest: {
      name: "Monthly Email Digest",
      subclass: "Destination::MonthlyEmailDigest",
      instant: false,
      destinable_type: :Email,
      destinable_label: :email,
      parameters: {
        hour: {
          default: "18",
          translate: false,
          kind: :select,
          options: Parameter::HOURS
        },
        day_of_month: {
          default: "1",
          translate: false,
          kind: :select,
          options: Parameter::DAYS_OF_MONTH
        }
      }
    }
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

  validates :destinable_type, inclusion: { in: ["Email"] }
  validates :destinable, presence: true
  validate :verified_destinable
  validate :own_destinable

  def self.kinds_options
    KINDS.map { |key, value| [value.fetch(:name), key] }
  end

  def self.kind_parameters
    KINDS.map { |key, value| [value.fetch(:parameters), key] }
  end

  def parameters_attributes=(*args)
    self.parameters = []
    super(*args)
  end

  def name
    KINDS.dig(kind.to_sym, :name)
  end

  def instant?
    KINDS.dig(kind.to_sym, :instant)
  end

  def subclass
    KINDS.dig(kind.to_sym, :subclass).constantize.new(self)
  end

  def send_now(items = nil)
    subclass.send_now(items)
  end

  def send_later(items = nil)
    SendToDestinationJob.perform_later(destination: self, items: items)
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
