class Destination
  class Email
    SUBJECT_DEFAULT = "{item.summary}"
    BODY_FORMAT_DEFAULT = "html"
    BODY_FORMATS =
      %w[text html].map do |body_format|
        [I18n.t("parameters.body_formats.#{body_format}"), body_format]
      end
    BODY_DEFAULT = <<~HTML
      {item.to_html}

      <a href="{pipeline.url}">{pipeline.url}</a>
    HTML

    def initialize(destination)
      @destination = destination
    end

    def self.fake_subjects
      [
        "{item.summary}",
        "{items.first.summary}",
        "{item.user_name}: {item.text}",
        "Summary of tweets",
        "New tweet"
      ].shuffle
    end

    def self.fake_bodies
      %w[
        {item.to_text}
        {item.to_html}
        {items.first.to_text}
        {items.first.to_html}
        {pipeline.url}
      ].shuffle
    end

    def self.fake_tos
      (1..3).map { Faker::Internet.email }
    end

    def self.subject_parameter
      {
        name: :subject,
        type: :string,
        default: SUBJECT_DEFAULT,
        fakes: fake_subjects,
        scope: :email
      }
    end

    def self.body_format_parameter
      {
        name: :body_format,
        type: :list,
        default: BODY_FORMAT_DEFAULT,
        options: BODY_FORMATS,
        scope: :email
      }
    end

    def self.body_parameter
      {
        name: :body,
        type: :text,
        default: BODY_DEFAULT,
        fakes: fake_bodies,
        scope: :email
      }
    end

    def self.default_to_for(user)
      return unless user
      email = user.emails.find(&:verified?) || user.emails.first
      email&.email
    end

    def self.to_parameter_for(user)
      {
        name: :to,
        type: :email,
        default: default_to_for(user),
        fakes: fake_tos,
        required: true,
        autocomplete: :email,
        data_form_type: :email,
        scope: :email
      }
    end

    def self.parameters_for(user)
      [
        subject_parameter,
        body_format_parameter,
        body_parameter,
        to_parameter_for(user)
      ]
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

    delegate :params, :pipeline, to: :destination

    def subject(item)
      Template.render(
        params[:subject],
        ruby: {item: item, pipeline: pipeline}.as_json
      )
    end

    def body(item)
      Template.render(
        params[:body],
        ruby: {item: item, pipeline: pipeline}.as_json
      )
    end

    def to
      params[:to]
    end

    def body_format
      params[:body_format].inquiry
    end
  end
end
