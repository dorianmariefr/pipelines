class DestinationPolicy < ApplicationPolicy
  def update?
    can?(:update, pipeline)
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
