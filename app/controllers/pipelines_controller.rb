class PipelinesController < ApplicationController
  MAX_ERROR_SIZE = 280

  before_action :load_user, only: :index
  before_action :load_pipeline,
    only: %i[show edit update destroy process_now duplicate]
  helper_method :password_param

  def index
    authorize Pipeline
    @pipelines = policy_scope(Pipeline).order(created_at: :asc)
    @pipelines = (@user ? @pipelines.where(user: @user) : @pipelines.published)
  end

  def show
    @sources = policy_scope(Source).joins(:pipeline).where(pipelines: @pipeline)
    @destinations =
      policy_scope(Destination).joins(:pipeline).where(pipelines: @pipeline)
    @items =
      policy_scope(Item)
        .joins(:pipeline)
        .where(pipelines: @pipeline)
        .eager_load(:source)
        .order(created_at: :desc)
        .page(params[:page])
  end

  def process_now
    pipeline_result = @pipeline.process_now

    if pipeline_result.error?
      redirect_back(
        fallback_location: @pipeline,
        alert:
          t(".alert", result: pipeline_result.to_s.truncate(MAX_ERROR_SIZE))
      )
    else
      redirect_back(
        fallback_location: @pipeline,
        notice: t(".notice", result: pipeline_result.to_s)
      )
    end
  end

  def duplicate
    @pipeline = @pipeline.duplicate_for(current_user)
    build_pipeline
  end

  def new
    @pipeline = authorize Pipeline.new
    build_pipeline
  end

  def create
    @pipeline = authorize Pipeline.new(pipeline_params)
    @pipeline.user = current_user if current_user

    if @pipeline.save
      session[:user_id] = @pipeline.user.id

      redirect_to pipeline_path(@pipeline), notice: t(".notice")
    else
      build_pipeline
      flash.now.alert = @pipeline.alert
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    build_pipeline
  end

  def update
    if @pipeline.update(pipeline_params)
      redirect_to pipeline_path(@pipeline), notice: t(".notice")
    else
      build_pipeline
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
    return if params[:user_id].blank?
    @user = policy_scope(User).friendly.find(params[:user_id])
  end

  def load_pipeline
    @pipeline =
      authorize(
        policy_scope(Pipeline).friendly.find(
          params[:id].presence || params[:pipeline_id]
        )
      )
  end

  def pipeline_params
    params.require(:pipeline).permit(
      :name,
      :published,
      user_attributes: [
        :avatar,
        :name,
        :locale,
        :time_zone,
        :password,
        emails_attributes: %i[_destroy email],
        phone_numbers_attributes: %i[_destroy phone_number]
      ],
      sources_attributes: [
        :id,
        :kind,
        :filter_type,
        :key,
        :transform,
        :operator,
        :value,
        :filter,
        :_destroy,
        parameters_attributes: %i[key value]
      ],
      destinations_attributes: [
        :id,
        :kind,
        :_destroy,
        parameters_attributes: %i[key value]
      ]
    )
  end

  def password_param
    params.dig(:pipeline, :user_attributes, :password)
  end

  def build_pipeline
    @pipeline.sources.build if @pipeline.sources.none?
    @pipeline.destinations.build if @pipeline.destinations.none?
    @pipeline.user = @pipeline.user || current_user || User.new
    return if current_user
    @pipeline.user.emails.build if @pipeline.user.emails.none?
    @pipeline.user.phone_numbers.build if @pipeline.user.phone_numbers.none?
  end
end
