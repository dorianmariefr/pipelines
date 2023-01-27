class AccountsController < ApplicationController
  before_action { authorize :account }
  before_action { @user = current_user }

  def show
    @emails = policy_scope(Email).where(user: @user).order(created_at: :asc)
    @phone_numbers =
      policy_scope(PhoneNumber).where(user: @user).order(created_at: :asc)
  end
end
