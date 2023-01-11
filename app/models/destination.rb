class Destination < ApplicationRecord
  KINDS = {
    email: {
      name: "Email",
      subclass: "Destination::Email",
      destinable_type: :Email,
      destinable_label: :email
    },
    hourly_email_digest: {
      name: "Hourly Email Digest",
      subclass: "Destination::HourlyEmailDigest",
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
    daily_email_digest: {
      name: "Daily Email Digest",
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
      name: "Weekly Email Digest",
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
      name: "Monthly Email Digest",
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

  has_many :parameters, as: :parameterizable, dependent: :destroy

  accepts_nested_attributes_for :parameters

  validates :destinable_type, inclusion: {in: ["Email"]}
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

  def subclass
    KINDS.dig(kind.to_sym, :subclass).constantize.new(self)
  end

  def send_now(item)
    subclass.send_now(item)
  end

  def send_later(item)
    SendToDestinationJob.perform_later(destination: self, item: item)
  end

  def parameters_hash
    parameters.map { |parameter| [parameter.key, parameter.value] }.to_h
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
