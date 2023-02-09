class ItemsController < ApplicationController
  before_action :load_pipeline, only: %i[destroy_all]

  def destroy_all
    authorize @pipeline

    policy_scope(Item).joins(:pipeline).where(pipelines: @pipeline).destroy_all

    redirect_back(fallback_location: @pipeline, notice: t(".notice"))
  end

  private

  def load_pipeline
    @pipeline = policy_scope(Pipeline).friendly.find(params[:pipeline_id])
  end
end
