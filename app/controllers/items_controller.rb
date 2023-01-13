class ItemsController < ApplicationController
  before_action :load_pipeline

  def index
    @items = @pipeline.items.includes(:source).order(created_at: :desc)
    respond_to do |format|
      format.html
      format.rss { render layout: false }
    end
  end

  private

  def load_pipeline
    @pipeline = policy_scope(Pipeline).find_by_id_or_slug!(params[:pipeline_id])
  end
end
