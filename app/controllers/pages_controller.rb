class PagesController < ApplicationController
  before_action { authorize :page }

  def home
  end

  def privacy
  end

  def terms
  end
end
