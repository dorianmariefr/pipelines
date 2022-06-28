class EmailPreview < ActionMailer::Preview
  include FactoryBot::Syntax::Methods

  def verification_email
    EmailMailer.with(email: Email.last!).verification_email
  end
end
