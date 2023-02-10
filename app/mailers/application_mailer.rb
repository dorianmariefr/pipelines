class ApplicationMailer < ActionMailer::Base
  default from: "Dorian Marié <dorian@pipelines.plumbing>"
  layout "mailer"

  rescue_from ActiveJob::DeserializationError

  def to(email)
    email_address_with_name(email.email, email.user.name)
  end
end
