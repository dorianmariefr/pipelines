module ApplicationHelper
  def title 
    action = action_name.to_sym
    action = :new if action == :create
    action = :edit if action == :update
    t("#{controller_name}.#{action}.title")
  end
end
