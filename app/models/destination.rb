class Destination < ApplicationRecord
  KINDS = {
    email: {
      subclass: "Destination::Email",
      destinable_type: :Email,
      destinable_label: :email
    },
    hourly_email_digest: {
      subclass: "Destination::HourlyEmailDigest",
      destinable_type: :Email,
      destinable_label: :email
    },
    daily_email_digest: {
      subclass: "Destination::DailyEmailDigest",
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
      subclass: "Destination::WeeklyEmailDigest",
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
      subclass: "Destination::MonthlyEmailDigest",
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
  scope :instant, -> { email }

  validates :destinable_type, inclusion: {in: ["Email"]}
  validates :destinable, presence: true
  validate :verified_destinable
  validate :own_destinable

  def self.kinds_options
    KINDS.map { |kind, _| [I18n.t("destinations.model.kinds.#{kind}"), kind] }
  end

  def parameters_attributes=(*args)
    self.parameters = []
    super(*args)
  end

  def name
    I18n.t("destinations.model.kinds.#{kind}")
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
