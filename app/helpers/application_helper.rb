module ApplicationHelper
  def title 
    action = action_name.to_sym
    action = :new if action == :create
    action = :edit if action == :update
    content_for?(:title) ? content_for(:title) : t("#{controller_name}.#{action}.title")
  end
end
