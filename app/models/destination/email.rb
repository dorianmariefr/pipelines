class Destination
  class Email
    BODY_FORMATS =
      %w[text html].map { |body_format| [body_format, body_format] }

    def initialize(destination)
      @destination = destination
    end

    def self.destinable_type
      :Email
    end

    def self.destinable_label
      :email
    end

    def self.subject_parameter
      {default: Source.email_subject_defaults, kind: :string, template: true}
    end

    def self.body_format_parameter
      {default: "text", kind: :select, options: BODY_FORMATS}
    end

    def self.body_parameter
      {default: Source.email_body_defaults, kind: :text, template: true}
    end

    def self.as_json
      {
        destinable_type: destinable_type,
        destinable_label: destinable_label,
        parameters: {
          subject: subject_parameter,
          body_format: body_format_parameter,
          body: body_parameter
        }
      }
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

    delegate :destinable, :params, :pipeline, to: :destination

    def subject(item)
      Template.render(params[:subject], ruby: item.as_json)
    end

    def body(item)
      Template.render(params[:body], ruby: item.as_json)
    end

    def to
      destinable.email
    end

    def body_format
      params[:body_format].inquiry
    end
  end
end
