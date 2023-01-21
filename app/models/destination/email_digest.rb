class Destination
  class EmailDigest < Email
    HOURS = (0..23).map { |hour| [hour.to_s, "#{hour}:00"] }

    def self.subject_parameter
      {
        default: Source.email_digest_subject_defaults,
        kind: :string,
        template: true
      }
    end

    def self.body_parameter
      {
        default: Source.email_digest_body_defaults,
        kind: :text,
        template: true
      }
    end

    def self.hour_parameter
      {default: "18", kind: :select, translate: false, options: HOURS}
    end

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

    def as_json(...)
      {items: items, pipeline: pipeline}.as_json(...)
    end
  end
end
