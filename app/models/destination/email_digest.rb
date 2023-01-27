class Destination
  class EmailDigest < Email
    HOURS = (0..23).map { |hour| [hour.to_s, "#{hour}:00"] }

    def self.subject_parameter
      {default: "{items.first.summary}", kind: :string, template: true}
    end

    def self.body_parameter
      {default: {text: <<~TEXT, html: <<~HTML}, kind: :text, template: true}
        {items.each do |item|
          puts(item.to_text)
          puts
          puts("⎯" * 80)
          puts
        end
        nothing}

        {pipeline.url}
      TEXT
        {items.each do |item|
          puts(item.to_html)
          puts
          puts("<br><br>")
          puts
        end
        nothing}

        {pipeline.url}
      HTML
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
