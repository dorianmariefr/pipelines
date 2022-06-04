class PhoneNumber::SendVerificationJob < ApplicationJob
  queue_as :default

  def perform(phone_number:)
    Sms.send_verification_code(phone_number)
  end
end
