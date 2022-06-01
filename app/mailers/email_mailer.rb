class EmailMailer < ApplicationMailer
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
end
