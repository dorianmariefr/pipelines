class PagePolicy < ApplicationPolicy
  def home?
    true
  end

  def privacy?
    true
  end

  def terms?
    true
  end

  def pro?
    true
  end
end
