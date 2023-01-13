class EmailMailer < ApplicationMailer
  def email
    mail(to: params[:to], subject: params[:subject], body: params[:body])
  end

  def rich_email
    @body = params[:body]
    mail(to: params[:to], subject: params[:subject])
  end

  def verification_email
    @email = params[:email]
    @user = @email.user
    @verification_code = @email.verification_code_formatted
    @url =
      email_url(
        @email.verification_signed_id,
        verification_code: @verification_code
      )

    mail(
      to: to(@email),
      subject:
        t(
          "email_mailer.verification_email.subject",
          verification_code: @verification_code
        )
    )
  end

  def password_reset_email
    @email = params[:email]
    @user = @email.user

    mail(
      to: to(@email),
      subject: t("email_mailer.password_reset_email.subject"),
      body: @user.reset_password_url
    )
  end
end
