class PipelinePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    published? || owner? || admin?
  end

  def create?
    current_user?
  end

  def process_now?
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
      admin? ? scope.all : scope.published.or(scope.where(user: current_user))
    end
  end

  private

  def published?
    record.published?
  end

  def owner?
    current_user? && record.user && current_user == record.user
  end
end
