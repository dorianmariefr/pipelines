class AccountPolicy < ApplicationPolicy
  def show?
    current_user?
  end
end
