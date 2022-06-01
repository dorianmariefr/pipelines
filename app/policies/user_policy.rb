class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    self? || admin?
  end

  def create?
    true
  end

  def update?
    self? || admin?
  end

  def destroy?
    self? || admin?
  end

  class Scope < Scope
    def resolve
      if admin?
        scope.all
      elsif current_user?
        scope.where(id: current_user.id)
      else
        scope.none
      end
    end
  end

  private

  def self?
    current_user? && record && current_user == record
  end
end
