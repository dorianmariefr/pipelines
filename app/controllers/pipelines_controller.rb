class PipelinesController < ApplicationController
  before_action :load_user, only: :index
  before_action :load_pipeline, only: %i[show edit update destroy process_now]

  def index
    authorize Pipeline

    @pipelines = policy_scope(Pipeline).order(created_at: :asc)

    @pipelines =
      (@user ? @pipelines.where(user: current_user) : @pipelines.published)
  end

  def show
    @sources = @pipeline.sources
    @destinations = @pipeline.destinations
  end

  def process_now
    @pipeline.process_now
  end

  def new
    @pipeline = authorize Pipeline.new
    build_source
    build_destination
  end

  def create
    @pipeline = Pipeline.new(pipeline_params)
    @pipeline.user = current_user
    authorize @pipeline

    if @pipeline.save
      redirect_to pipeline_path(@pipeline), notice: t(".notice")
    else
      build_source
      build_destination
      flash.now.alert = @pipeline.alert
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    build_source
    build_destination
  end

  def update
    if @pipeline.update(pipeline_params)
      redirect_to pipeline_path(@pipeline), notice: t(".notice")
    else
      build_source
      build_destination
      flash.now.alert = @pipeline.alert
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pipeline.destroy!

    redirect_to user_pipelines_path(current_user), notice: t(".notice")
  end

  private

  def load_user
    @user = policy_scope(User).friendly.find(params[:user_id]) if params[
      :user_id
    ]
  end

  def load_pipeline
    @pipeline =
      authorize(
        policy_scope(Pipeline).find_by_id_or_slug!(
          params[:id].presence || params[:pipeline_id]
        )
      )
  end

  def pipeline_params
    params.require(:pipeline).permit(
      :name,
      :published,
      sources_attributes: %i[id kind filter _destroy],
      destinations_attributes: %i[
        id
        kind
        destinable_type
        destinable_id
        _destroy
      ]
    )
  end

  def build_source
    @pipeline.sources.build if @pipeline.sources.none?
  end

  def build_destination
    @pipeline.destinations.build if @pipeline.destinations.none?
  end
end
