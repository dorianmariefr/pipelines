class SessionPolicy < ApplicationPolicy
  def create?
    true
  end

  def destroy?
    true
  end

  def reset?
    true
  end
end
