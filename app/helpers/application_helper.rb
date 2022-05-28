module ApplicationHelper
  def title 
    t("#{controller_name}.#{action_name}.title")
  end
end
