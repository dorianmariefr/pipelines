class Admin
  class EmailsController < ApplicationController
    before_action { authorize [:admin, Email] }
    before_action :load_email, only: %i[show update destroy send_verification]

    def show
      @verification_code = params[:verification_code]
    end

    def send_verification
      @email.send_verification!

      redirect_back_or_to admin_user_path(@email.user), notice: t(".notice")
    end

    def create
      @email = Email.new(email_params)
      authorize @email

      if @email.save
        redirect_to admin_user_path(@email.user), notice: t(".notice")
      else
        redirect_to admin_user_path(@email.user), alert: @email.alert
      end
    end

    def update
      if @email.verify(verification_code_param)
        redirect_back fallback_location: admin_users_path, notice: t(".notice")
      else
        flash.now.alert = t(".alert")
        render :show, status: :unprocessable_entity
      end
    end

    def destroy
      @email.destroy!

      redirect_to admin_user_path(@email.user), notice: t(".notice")
    end

    private

    def load_email
      @email =
        authorize(
          [:admin, policy_scope(Email).find(params[:id] || params[:email_id])]
        )
    end

    def email_params
      params.require(:email).permit(:email, :verified, :user_id)
    end

    def verification_code_param
      params.require(:email)[:verification_code]
    end
  end
end
