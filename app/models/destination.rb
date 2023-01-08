class Destination < ApplicationRecord
  KINDS = {email: {name: "Email", subclass: "Destination::Email"}}

  belongs_to :pipeline
  belongs_to :destinable, polymorphic: true

  has_many :parameters, as: :parameterizable, dependent: :destroy

  validates :destinable_type, inclusion: {in: ["Email"]}
  validate :verified_destinable

  def self.kinds_options
    KINDS.map { |key, value| [value.fetch(:name), key] }
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

  def verified_destinable
    if !destinable || !destinable.verified?
      errors.add(:destinable, I18n.t("errors.not_verified"))
    end
  end
end
