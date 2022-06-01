class PhoneNumbersController < ApplicationController
  before_action :load_phone_number, only: %i[show update send_verification]
  before_action :load_user

  def show
    @verification_code = params[:verification_code]
  end

  def send_verification
    @phone_number.send_verification!

    redirect_to user_path(@user), notice: t(".notice")
  end

  def create
    @phone_number = @user.phone_numbers.build(phone_number_params)
    authorize @phone_number

    if @phone_number.save
      redirect_to user_path(@user), notice: t(".notice")
    else
      redirect_to user_path(@user), alert: @phone_number.alert
    end
  end

  def update
    if @phone_number.verify(verification_code_param)
      redirect_back fallback_location: root_path, notice: t(".notice")
    else
      flash.now.alert = t(".alert")
      render :show, status: :unprocessable_entity
    end
  end

  private

  def load_phone_number
    @phone_number =
      PhoneNumber.find_signed!(
        params[:id],
        purpose: PhoneNumber::SIGNED_ID_PURPOSE
      )
    skip_authorization
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    @phone_number =
      authorize(
        policy_scope(PhoneNumber).find(params[:id] || params[:phone_number_id])
      )
  end

  def load_user
    @user =
      if @phone_number
        @phone_number.user
      else
        policy_scope(User).friendly.find(params[:user_id])
      end
  end

  def phone_number_params
    params.require(:phone_number).permit(:phone_number)
  end

  def verification_code_param
    params.require(:phone_number)[:verification_code]
  end
end
