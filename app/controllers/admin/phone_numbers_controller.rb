class Admin
  class PhoneNumbersController < ApplicationController
    before_action { authorize [:admin, PhoneNumber] }
    before_action :load_phone_number,
      only: %i[show update destroy send_verification]

    def show
    end

    def send_verification
      @phone_number.send_verification!

      redirect_back_or_to admin_user_path(@phone_number.user),
        notice: t(".notice")
    end

    def create
      @phone_number = PhoneNumber.new(phone_number_params)
      authorize @phone_number

      if @phone_number.save
        redirect_to admin_user_path(@phone_number.user), notice: t(".notice")
      else
        redirect_to admin_user_path(@phone_number.user),
          alert: @phone_number.alert
      end
    end

    def update
      if @phone_number.verify(verification_code_param)
        redirect_back_or_to admin_users_path, notice: t(".notice")
      else
        flash.now.alert = t(".alert")
        render :show, status: :unprocessable_entity
      end
    end

    def destroy
      @phone_number.destroy!

      redirect_to admin_user_path(@phone_number.user), notice: t(".notice")
    end

    private

    def load_phone_number
      @phone_number =
        authorize(
          [
            :admin,
            policy_scope(PhoneNumber).find(
              params[:id] || params[:phone_number_id]
            )
          ]
        )
    end

    def phone_number_params
      params.require(:phone_number).permit(:phone_number, :verified, :user_id)
    end

    def verification_code_param
      params.require(:phone_number).fetch(:verification_code, "")
    end
  end
end
