class SessionsController < ApplicationController
  before_action { authorize :session }
  before_action :load_email, only: :create
  before_action :load_phone_number, only: :create
  before_action :load_user, only: :create

  helper_method :email_param, :password_param
  helper_method :phone_number_param, :password_param
  helper_method :password_param, :password_param

  def new
  end

  def create
    if @user&.authenticate(password_param)
      session[:user_id] = @user.id
      redirect_to root_path, notice: t(".notice")
    elsif @user
      flash.now.alert = t(".wrong_password")
      render :new, status: :unprocessable_entity
    elsif email_param.present?
      flash.now.alert = t(".wrong_email")
      render :new, status: :unprocessable_entity
    elsif phone_number_param.present?
      flash.now.alert = t(".wrong_phone_number")
      render :new, status: :unprocessable_entity
    else
      flash.now.alert = t(".must_be_present")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: t(".notice")
  end

  private

  def session_params
    params.require(:session).permit(:email, :phone_number, :password)
  rescue ActionController::ParameterMissing
    {}
  end

  def email_param
    session_params[:email]
  end

  def phone_number_param
    session_params[:phone_number]
  end

  def password_param
    session_params[:password]
  end

  def load_email
    @email = Email.find_by_normalized_email(email_param)
  end

  def load_phone_number
    @phone_number = PhoneNumber.find_by_normalized_phone_number(phone_number_param)
  end

  def load_user
    @user = @email&.user || @phone_number&.user
  end
end
