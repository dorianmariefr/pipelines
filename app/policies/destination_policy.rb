class DestinationPolicy < ApplicationPolicy
  def update?
    can?(:update, pipeline)
  end

  private

  def pipeline
    record.pipeline
  end
end
