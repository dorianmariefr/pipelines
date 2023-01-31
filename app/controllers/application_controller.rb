class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include CanConcern

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  helper_method :current_user
  helper_method :can?

  rescue_from Pundit::NotAuthorizedError do |e|
    redirect_to root_path, alert: e.message
  end

  private

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
