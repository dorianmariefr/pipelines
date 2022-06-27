class PhoneNumberPolicy < ApplicationPolicy
  def send_verification?
    owner? || admin?
  end

  def show?
    owner? || admin?
  end

  def create?
    owner? || admin?
  end

  def update?
    owner? || admin?
  end

  def destroy?
    owner? || admin?
  end

  class Scope < Scope
    def resolve
      scope.where(user: policy_scope(User))
    end
  end

  private

  def user
    record.user
  end

  def user?
    !!user
  end

  def owner?
    user? && current_user? && user == current_user
  end
end
