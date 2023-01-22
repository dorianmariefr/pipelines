class Admin
  class UsersController < ApplicationController
    before_action { authorize [:admin, User] }
    before_action :load_user, only: %i[show edit update destroy impersonate]

    helper_method :password_param

    def index
      @users = policy_scope(User).order(created_at: :asc)
    end

    def show
      @emails =
        policy_scope(Email).where(user: @user).order(created_at: :asc).to_a
      @emails << Email.new(user: @user)
      @phone_numbers =
        policy_scope(PhoneNumber)
          .where(user: @user)
          .order(created_at: :asc)
          .to_a
      @phone_numbers << PhoneNumber.new(user: @user)
      @pipelines =
        policy_scope(Pipeline).where(user: @user).order(created_at: :asc)
    end

    def impersonate
      session[:user_id] = @user.id

      redirect_to root_path, notice: t(".notice")
    end

    def new
      @user = User.new
      build_user
    end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to [:admin, @user], notice: t(".notice")
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
        redirect_to [:admin, @user], notice: t(".notice")
      else
        build_user
        flash.now.alert = @user.alert
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy!

      redirect_to admin_users_path, notice: t(".notice")
    end

    private

    def load_user
      @user =
        authorize(
          [
            :admin,
            policy_scope(User).friendly.find(
              params[:user_id].presence || params[:id]
            )
          ]
        )
    end

    def user_params
      params.require(:user).permit(
        :avatar,
        :pro,
        :name,
        :locale,
        :time_zone,
        :password,
        emails_attributes: %i[id email verified _destroy],
        phone_numbers_attributes: %i[id phone_number verified _destroy]
      )
    end

    def password_param
      params.dig(:user, :password)
    end

    def build_user
      @user.emails.build if @user.emails.none?
      @user.phone_numbers.build if @user.phone_numbers.none?
    end
  end
end
