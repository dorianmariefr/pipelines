class SourcePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      admin? ? scope.all : scope.joins(:pipeline).merge(policy_scope(Pipeline))
    end
  end
end
