class PipelinePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    published? || owner? || admin?
  end

  def create?
    true
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

  def destroy_all?
    owner? || admin?
  end

  def duplicate?
    true
  end

  class Scope < Scope
    def resolve
      if admin?
        scope.all
      elsif current_user?
        scope.published.or(scope.where(user: current_user))
      else
        scope.published
      end
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
