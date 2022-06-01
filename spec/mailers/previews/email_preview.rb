class EmailPreview < ActionMailer::Preview
  include FactoryBot::Syntax::Methods

  def verification_email
    EmailMailer.with(email: create(:email)).verification_email
  end
end
