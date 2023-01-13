class PostPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def send_later?
    admin?
  end

  def create?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
