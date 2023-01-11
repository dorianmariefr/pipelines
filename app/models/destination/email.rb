class Destination
  class Email
    def initialize(destination)
      @destination = destination
    end

    def send_now(items)
      items.each do |item|
        EmailMailer
          .with(to: to, subject: item.email_subject, body: item.email_body)
          .email
          .deliver_later
      end
    end

    private

    attr_reader :destination

    def to
      destination.destinable.email
    end
  end
end
