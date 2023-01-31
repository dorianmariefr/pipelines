class PhoneNumbersController < ApplicationController
  before_action :load_phone_number,
                only: %i[show update destroy send_verification]

  def show
  end

  def send_verification
    @phone_number.send_verification!

    redirect_back(
      fallback_location: user_path(@phone_number.user),
      notice: t(".notice")
    )
  end

  def update
    if @phone_number.verify(verification_code_param)
      redirect_back_or_to root_path, notice: t(".notice")
    else
      flash.now.alert = t(".alert")
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @phone_number.destroy!

    redirect_to account_path, notice: t(".notice")
  end

  private

  def load_phone_number
    @phone_number =
      authorize(
        policy_scope(PhoneNumber).find(params[:id] || params[:phone_number_id])
      )
  end

  def verification_code_param
    params.dig(:phone_number, :verification_code)
  end
end
