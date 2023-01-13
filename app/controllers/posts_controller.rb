class PostsController < ApplicationController
  before_action :load_post, only: %i[show edit update destroy send_later]

  def index
    @posts = policy_scope(Post).order(created_at: :desc)
  end

  def show
  end

  def new
    @post = authorize Post.new
  end

  def create
    @post = Post.new(post_params)
    authorize @post

    if @post.save
      redirect_to @post, notice: t(".notice")
    else
      flash.now.alert = @post.alert
      render :new, status: :unprocessable_entity
    end
  end

  def send_later
    @post.send_later

    redirect_to @post, notice: t(".notice")
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: t(".notice")
    else
      flash.now.alert = @post.alert
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!

    redirect_to posts_path, notice: t(".notice")
  end

  private

  def load_post
    @post =
      authorize policy_scope(Post).find(
        params[:post_id].presence || params[:id]
      )
  end

  def post_params
    params.require(:post).permit(:title, :description)
  end
end
