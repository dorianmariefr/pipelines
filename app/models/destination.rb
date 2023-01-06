class Destination < ApplicationRecord
  KINDS = {email: {name: "Email", model: :email}}

  belongs_to :pipeline
  belongs_to :destinable, polymorphic: true

  has_many :parameters, as: :parameterable

  validates :destinable_type, inclusion: {in: ["Email"]}
  validate :verified_destinable

  def self.kinds_options
    KINDS.map { |key, value| [value.fetch(:name), key] }
  end

  def name
    KINDS.dig(kind.to_sym, :name)
  end

  def model
    KINDS.dig(kind.to_sym, :model)
  end

  private

  def verified_destinable
    if !destinable || !destinable.verified?
      errors.add(:destinable, I18n.t("errors.not_verified"))
    end
  end
end
