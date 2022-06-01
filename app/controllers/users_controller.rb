class UsersController < ApplicationController
  before_action :load_user, only: %i[show edit update destroy]

  def index
    authorize :user
    @users = policy_scope(User)
  end

  def show
    @emails = @user.emails.order(created_at: :asc).to_a
    @emails << @user.emails.build
    @phone_numbers = @user.phone_numbers.order(created_at: :asc).to_a
    @phone_numbers << @user.phone_numbers.build
  end

  def new
    @user = User.new
    build_user
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user

    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user), notice: t(".notice")
    else
      build_user
      flash.now.alert = @user.alert
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    build_user
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: t(".notice")
    else
      build_user
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
    @user = authorize policy_scope(User).friendly.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :name,
      :password,
      emails_attributes: %i[id email _destroy],
      phone_numbers_attributes: %i[id phone_number _destroy]
    )
  end

  def build_user
    @user.emails.build if @user.emails.none?
    @user.phone_numbers.build if @user.phone_numbers.none?
  end
end
