class Destination < ApplicationRecord
  KINDS = {
    email: {
      name: "Email"
    },
    email_digest: {
      name: "Email Digest"
    },
    sms: {
      name: "SMS"
    },
    sms_digest: {
      name: "SMS Digest"
    }
  }

  belongs_to :pipeline

  has_many :parameters, as: :parameterable

  def self.kinds_options
    KINDS.map { |key, value| [value.fetch(:name), key] }
  end
end
