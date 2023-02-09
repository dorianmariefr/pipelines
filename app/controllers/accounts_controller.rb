class AccountsController < ApplicationController
  before_action :load_account,
    only: %i[show edit update destroy redirect_authorize]
  before_action :load_user

  def index
    authorize Account
    @accounts = policy_scope(Account).where(user: @user).order(created_at: :asc)
  end

  def show
  end

  def callback
    authorize Account
    @account = Account.find(session[:account_id])
    @account.callback(params[:code])
    redirect_to @account, notice: t(".notice")
  end

  def redirect_authorize
    session[:account_id] = @account.id
    redirect_to @account.authorize_url, allow_other_host: true
  end

  def new
    @account = authorize Account.new
  end

  def create
    @account = Account.new(account_params)
    @account.user = current_user
    authorize @account

    if @account.save
      @account.application!
      redirect_to @account, notice: t(".notice")
    else
      flash.now.alert = @account.alert
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @account.update(account_params)
      @account.update!(extras: {})
      @account.application!
      redirect_to @account, notice: t(".notice")
    else
      flash.now.alert = @account.alert
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy!

    redirect_to accounts_path, notice: t(".notice")
  end

  private

  def load_account
    @account =
      authorize policy_scope(Account).find(
        params[:account_id].presence || params[:id]
      )
  end

  def load_user
    @user = @account&.user || current_user
  end

  def account_params
    params.require(:account).permit(:kind, :external_id, scope: [])
  end
end
