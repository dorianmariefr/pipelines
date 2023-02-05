class AccountPolicy < ApplicationPolicy
  def index?
    current_user?
  end

  def show?
    owner? || admin?
  end

  def redirect_authorize?
    owner? || admin?
  end

  def callback?
    current_user?
  end

  def create?
    current_user?
  end

  def update?
    owner? || admin?
  end

  def destroy?
    owner? || admin?
  end

  class Scope < Scope
    def resolve
      if admin?
        scope.all
      elsif current_user?
        scope.where(user: current_user)
      else
        scope.none
      end
    end
  end

  private

  def user
    record.user
  end

  def owner?
    user && current_user && user == current_user
  end
end
