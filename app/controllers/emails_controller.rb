class EmailsController < ApplicationController
  before_action :load_email, only: %i[show update destroy send_verification]

  def show
    @verification_code = params[:verification_code]
  end

  def send_verification
    @email.send_verification!

    redirect_back_or_to user_path(@email.user), notice: t(".notice")
  end

  def create
    @email = Email.new(email_params)
    @email.user = current_user
    authorize @email

    if @email.save
      redirect_to user_path(@email.user), notice: t(".notice")
    else
      redirect_to user_path(@email.user), alert: @email.alert
    end
  end

  def update
    if @email.verify(verification_code_param)
      redirect_back fallback_location: root_path, notice: t(".notice")
    else
      flash.now.alert = t(".alert")
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @email.destroy!

    redirect_to user_path(@email.user), notice: t(".notice")
  end

  private

  def load_email
    @email = Email.find_signed!(params[:id], purpose: Email::SIGNED_ID_PURPOSE)
    skip_authorization
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    @email =
      authorize policy_scope(Email).find(params[:id] || params[:email_id])
  end

  def email_params
    params.require(:email).permit(:email)
  end

  def verification_code_param
    params.require(:email)[:verification_code]
  end
end
