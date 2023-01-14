class PagesController < ApplicationController
  before_action { authorize :page }

  def home
    @pipelines = policy_scope(Pipeline).where(user: current_user)
    @published_pipelines = policy_scope(Pipeline).published
    @published_users = policy_scope(User).published
    @posts = policy_scope(Post).order(created_at: :desc)
  end

  def privacy
  end

  def terms
  end

  def pro
  end
end
