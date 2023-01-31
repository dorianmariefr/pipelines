class Destination
  class EmailDigest < Email
    def send_now(items)
      if body_format.html?
        EmailMailer
          .with(to: to, subject: subject, body: body)
          .html_email
          .deliver_later
      else
        EmailMailer
          .with(to: to, subject: subject, body: body)
          .email
          .deliver_later
      end
    end

    def subject
      Template.render(params[:subject], ruby: as_json)
    end

    def body
      Template.render(params[:body], ruby: as_json)
    end

    private

    delegate :pipeline, to: :destination

    def as_json(...)
      { items: items, pipeline: pipeline }.as_json(...)
    end
  end
end
