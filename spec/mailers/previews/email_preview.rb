class EmailPreview < ActionMailer::Preview
  def verification_email
    EmailMailer.with(email: Email.last!).verification_email
  end

  def reset_password_email
    EmailMailer.with(email: Email.last!).password_reset_email
  end

  def rich_email
    EmailMailer.with(
      to: Email.last!.email,
      subject: Post.last!.title,
      body: Post.last!.description
    ).rich_email
  end
end
