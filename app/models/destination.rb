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
          options: (0..23).map(&:to_s)
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
          options: (0..23).map(&:to_s)
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
          options: (0..23).map(&:to_s)
        },
        day_of_week: {
          default: :thursday,
          translate: true,
          kind: :select,
          options: [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]
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
          options: (0..23).map(&:to_s)
        },
        day_of_month: {
          default: "1",
          translate: false,
          kind: :select,
          options: (1..31).map(&:to_s)
        }
      }
    }
  }

  belongs_to :pipeline
  belongs_to :destinable, polymorphic: true
  has_one :user, through: :pipeline

  has_many :parameters, as: :parameterizable, dependent: :destroy

  accepts_nested_attributes_for :parameters

  validates :destinable_type, inclusion: {in: ["Email"]}
  validate :verified_destinable
  validate :own_destinable

  def self.kinds_options
    KINDS.map { |key, value| [value.fetch(:name), key] }
  end

  def self.kind_parameters
    KINDS.map { |key, value| [value.fetch(:parameters), key] }
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

  private

  def own_destinable
    if (!destinable || destinable.user == user) && !user.admin?
      errors.add(:destinable, I18n.t("errors.not_own"))
    end
  end

  def verified_destinable
    if !destinable || !destinable.verified?
      errors.add(:destinable, I18n.t("errors.not_verified"))
    end
  end
end
