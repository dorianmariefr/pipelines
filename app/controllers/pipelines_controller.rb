class PipelinesController < ApplicationController
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

    if pipeline_result.errors?
      redirect_back(fallback_location: @pipeline, alert: t(".alert"))
    else
      redirect_back(
        fallback_location: @pipeline,
        notice: t(".notice", result: pipeline_result.to_s)
      )
    end
  end

  def duplicate
    @new_pipeline = @pipeline.duplicate_for(current_user)

    if @new_pipeline.save
      redirect_to @new_pipeline, notice: t(".notice")
    else
      redirect_back(fallback_location: @pipeline, alert: @new_pipeline.alert)
    end
  end

  def new
    @pipeline = authorize Pipeline.new
    build_pipeline
  end

  def create
    @pipeline = authorize Pipeline.new(pipeline_params)

    @user = current_user || User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      @pipeline.user = @user
      @pipeline.destinations.each do |destination|
        destination.destinable_id =
          @user
            .emails
            .find_by_normalized_email(destination.destinable_email)
            &.id
      end

      if @pipeline.save
        redirect_to pipeline_path(@pipeline), notice: t(".notice")
      else
        build_user
        build_pipeline
        flash.now.alert = @pipeline.alert
        render :new, status: :unprocessable_entity
      end
    else
      build_user
      build_pipeline
      flash.now.alert = @user.alert
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

  def user_params
    params.require(:user).permit(
      :name,
      :password,
      emails_attributes: [:email],
      phone_numbers_attributes: [:phone_number]
    )
  end

  def pipeline_params
    params.require(:pipeline).permit(
      :name,
      :published,
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
        :destinable_type,
        :destinable_email,
        :destinable_id,
        :_destroy,
        parameters_attributes: %i[key value]
      ]
    )
  end

  def password_param
    params.dig(:user, :password)
  end

  def build_pipeline
    @pipeline.sources.build if @pipeline.sources.none?
    @pipeline.destinations.build if @pipeline.destinations.none?
  end

  def build_user
    @user.emails.build if @user.emails.none?
    @user.phone_numbers.build if @user.phone_numbers.none?
  end
end
