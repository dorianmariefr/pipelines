class Destination < ApplicationRecord
  KINDS = {
    email: {
      name: "Email",
      model: :email
    },
    email_digest: {
      name: "Email Digest",
      model: :email
    },
    sms: {
      name: "SMS",
      model: :phone_number
    },
    sms_digest: {
      name: "SMS Digest",
      model: :phone_number
    }
  }

  belongs_to :pipeline
  belongs_to :destinable, polymorphic: true

  has_many :parameters, as: :parameterable

  def self.kinds_options
    KINDS.map { |key, value| [value.fetch(:name), key] }
  end

  def self.destinable_candidates_for(user)
    KINDS.transform_values do |value|
      if value[:model] == :email
        user.emails.verified
      elsif value[:model] == :phone_number
        user.phone_numbers.verified
      else
        raise NotImplementedError
      end
    end
  end

  def name
    KINDS.dig(kind.to_sym, :name)
  end

  def model
    KINDS.dig(kind.to_sym, :model)
  end
end
