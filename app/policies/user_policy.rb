class UserPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
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
      scope.all
    end
  end

  private

  def self?
    current_user? && record && current_user == record
  end
end
