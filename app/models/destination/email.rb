class Destination
  class Email
    def initialize(destination)
      @destination = destination
    end

    def send_now(items)
      items.each do |item|
        if body_format.html?
          EmailMailer
            .with(to: to, subject: subject(item), body: body(item))
            .html_email
            .deliver_later
        else
          EmailMailer
            .with(to: to, subject: subject(item), body: body(item))
            .email
            .deliver_later
        end
      end
    end

    def items
      []
    end

    private

    attr_reader :destination

    delegate :params, to: :destination

    def subject(item)
      Template.render(params[:subject], ruby: { item: item.as_json })
    end

    def body(item)
      Template.render(params[:body], ruby: { item: item.as_json })
    end

    def to
      params[:to]
    end

    def body_format
      params[:body_format].inquiry
    end
  end
end
