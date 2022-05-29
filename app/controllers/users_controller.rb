class UsersController < ApplicationController
  before_action :load_user, only: [:show, :edit, :update, :destroy]

  def index
    authorize :user
    @users = policy_scope(User)
  end

  def show
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: t(".notice")
    else
      flash.now.alert = @user.alert
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: t(".notice")
    else
      flash.now.alert = @user.alert
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!

    redirect_to root_path, notice: t(".notice")
  end

  private

  def load_user
    @user = authorize policy_scope(User).find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
