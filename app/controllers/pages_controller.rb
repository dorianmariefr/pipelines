class PagesController < ApplicationController
  before_action { authorize :page }

  def home
    @published_pipelines =
      policy_scope(Pipeline).published.order(created_at: :asc)
    @your_pipelines = policy_scope(Pipeline).where(user: current_user)
  end

  def privacy
  end

  def terms
  end
end
