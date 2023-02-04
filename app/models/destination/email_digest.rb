class Destination
  class EmailDigest < Email
    SUBJECT_DEFAULT = "{items.first.summary}"
    BODY_DEFAULT = <<~HTML
      {items.each { |item| puts(item.to_html) } nothing}

      <a href="{pipeline.url}">{pipeline.url}</a>
    HTML

    HOUR_DEFAULT = 18
    HOURS = (0..23).map { |hour| ["#{hour}:00", hour] }

    def self.subject_parameter
      {
        name: :subject,
        type: :string,
        default: SUBJECT_DEFAULT,
        fakes: fake_subjects
      }
    end

    def self.body_parameter
      {name: :body, type: :text, default: BODY_DEFAULT, fakes: fake_bodies}
    end

    def self.hour_parameter
      {name: :hour, type: :select, default: HOUR_DEFAULT, options: HOURS}
    end

    def send_now(items)
      return if items.none?

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

    def as_json(...)
      {items: items, pipeline: pipeline}.as_json(...)
    end
  end
end
