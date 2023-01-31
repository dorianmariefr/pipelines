class EmailsController < ApplicationController
  before_action :load_email, only: %i[show update destroy send_verification]

  def show
    @verification_code = params[:verification_code]
  end

  def send_verification
    @email.send_verification!

    redirect_back_or_to account_path, notice: t(".notice")
  end

  def update
    if @email.verify(verification_code_param)
      session[:user_id] = @email.user.id
      redirect_back fallback_location: root_path, notice: t(".notice")
    else
      flash.now.alert = t(".alert")
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @email.destroy!

    redirect_to account_path, notice: t(".notice")
  end

  private

  def load_email
    @email = Email.find_signed!(params[:id], purpose: Email::SIGNED_ID_PURPOSE)
    skip_authorization
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    @email =
      authorize policy_scope(Email).find(params[:id] || params[:email_id])
  end

  def verification_code_param
    params.dig(:email, :verification_code)
  end
end
