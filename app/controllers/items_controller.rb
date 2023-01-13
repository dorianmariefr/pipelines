class ItemsController < ApplicationController
  before_action :load_pipeline, only: %i[index destroy_all]
  before_action :load_item, only: :destroy

  def index
    @items =
      policy_scope(Item)
        .joins(:pipeline)
        .where(pipelines: @pipeline)
        .eager_load(:source)
        .order(created_at: :desc)
        .page(params[:page])

    respond_to do |format|
      format.html
      format.rss { render layout: false }
    end
  end

  def destroy_all
    authorize @pipeline

    policy_scope(Item).joins(:pipeline).where(pipelines: @pipeline).destroy_all

    redirect_back(fallback_location: @pipeline, notice: t(".notice"))
  end

  def destroy
    @item.destroy!

    redirect_back(fallback_location: @pipeline, notice: t(".notice"))
  end

  private

  def load_pipeline
    @pipeline = policy_scope(Pipeline).find_by_id_or_slug!(params[:pipeline_id])
  end

  def load_item
    @item = authorize policy_scope(Item).find(params[:id])
  end
end
