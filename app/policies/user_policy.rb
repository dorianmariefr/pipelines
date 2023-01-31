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
      if admin?
        scope.all
      elsif current_user?
        scope.published.or(
          scope.left_joins(:pipelines).where(id: current_user).distinct
        )
      else
        scope.published
      end
    end
  end

  private

  def self?
    current_user? && record && current_user == record
  end
end
