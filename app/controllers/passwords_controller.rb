class PasswordsController < ApplicationController
  before_action { authorize :password }
  before_action :load_user

  helper_method :password_param

  def edit
  end

  def update
    if @user.update(password: password_param)
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash.now.alert = @user.alert
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def load_user
    @user =
      User.find_signed(params[:user_id], purpose: User::RESET_PASSWORD_PURPOSE)
  end

  def password_param
    params.dig(:password, :password)
  end
end
