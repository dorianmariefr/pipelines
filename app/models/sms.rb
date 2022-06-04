class Sms
  attr_reader :phone_number

  def initialize(phone_number)
    @phone_number = phone_number
  end

  def self.send_verification_code(phone_number)
    new(phone_number).send_verification_code
  end

  def client
    @client ||= MessageBird::Client.new(ENV.fetch("MESSAGE_BIRD_ACCESS_KEY"))
  end

  def send_verification_code
    reference = "PhoneNumber##{id}.send_verification_code"
    client.verify_create(e164, reference: reference)
  end

  private

  def id
    phone_number.id
  end

  def phonelib
    phone_number.phonelib
  end

  def e164
    phone_number.e164
  end
end
