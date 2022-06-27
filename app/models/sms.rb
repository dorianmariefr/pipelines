class Sms
  ORIGINATOR = ENV.fetch("MESSAGE_BIRD_ORIGINATOR", "Dorian")
  ACCESS_KEY = ENV.fetch("MESSAGE_BIRD_ACCESS_KEY")
  VERIFY_TYPE = "flash"

  attr_reader :phone_number

  def initialize(phone_number)
    @phone_number = phone_number
  end

  def client
    @client ||= MessageBird::Client.new(ENV.fetch("MESSAGE_BIRD_ACCESS_KEY"))
  end

  def send_code
    reference = "PhoneNumber##{id}.send_code"

    client.verify_create(
      e164,
      reference: reference,
      originator: ORIGINATOR,
      type: VERIFY_TYPE
    )
  end

  def verify_code(code)
    client.verify_token(external_token, code)
  end

  private

  delegate :id, :phonelib, :e164, :external_token, to: :phone_number
end
