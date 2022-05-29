class SessionsController < ApplicationController
  before_action { authorize :session }

  helper_method :email_param, :password_param

  def new
  end

  def create
    @user = User.find_by(email: email_param)

    if @user&.authenticate(password_param)
      session[:user_id] = @user.id
      redirect_to root_path, notice: t(".notice")
    elsif @user
      flash.now.alert = t(".wrong_password")
      render :new, status: :unprocessable_entity
    else
      flash.now.alert = t(".wrong_email")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: t(".notice")
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

  def email_param
    session_params[:email]
  end

  def password_param
    session_params[:password]
  end
end
