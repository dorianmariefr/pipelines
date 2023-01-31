class PagesController < ApplicationController
  before_action { authorize :page }

  def home
    @pipelines = policy_scope(Pipeline).published.order(created_at: :asc)
  end

  def privacy
  end

  def terms
  end
end
