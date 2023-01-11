class Destination::DailyEmailDigest
  def initialize(destination)
    @destination = destination
  end

  def send_now(_)
    return if items.none?
    EmailMailer.with(to: to, subject: subject, body: body).email.deliver_later
  end

  private

  attr_reader :destination

  def items
    destination.items.where(created_at: 1.day.ago..)
  end

  def subject
    items.first.email_subject
  end

  def to
    destination.to
  end

  def body
    items
      .map { |item| "#{item.email_subject}\n\n#{item.email_body}" }
      .join("\n\n")
  end
end
