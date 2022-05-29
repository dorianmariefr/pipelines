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

    private

    attr_reader :current_user, :scope

    def current_user?
      !!current_user
    end

    def admin?
      current_user? && current_user.admin?
    end
  end

  private

  def self?
    current_user? && record && current_user == record
  end
end
