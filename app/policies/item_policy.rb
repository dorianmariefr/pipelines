class ItemPolicy < ApplicationPolicy
  def destroy_all?
    can?(:destroy, pipeline)
  end

  def destroy?
    can?(:destroy, pipeline)
  end

  class Scope < Scope
    def resolve
      admin? ? scope.all : scope.joins(:pipeline).merge(policy_scope(Pipeline))
    end
  end

  private

  def pipeline
    record.pipeline
  end
end
