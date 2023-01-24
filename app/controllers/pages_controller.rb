class PagesController < ApplicationController
  before_action { authorize :page }

  def home
    @users = policy_scope(User).published.order(created_at: :asc)
    render layout: "home"
  end

  def privacy
  end

  def terms
  end

  def pro
  end
end
