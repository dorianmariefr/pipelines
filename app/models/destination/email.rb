class Destination
  class Email
    def initialize(destination)
      @destination = destination
    end

    def send_now(item)
      EmailMailer
        .with(to: to, subject: item.subject, body: item.body)
        .email
        .deliver_now
    end

    private

    attr_reader :destination

    def to
      destination.destinable.email
    end
  end
end
