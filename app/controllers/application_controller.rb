class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include CanConcern

  before_action :set_locale
  before_action :update_locale
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

  def set_locale
    I18n.locale =
      if params[:locale] &&
          I18n.available_locales.map(&:to_s).include?(params[:locale].to_s)
        params[:locale]
      elsif current_user
        current_user.locale
      else
        http_accept_language.compatible_language_from(I18n.available_locales)
      end
  end

  def update_locale
    if current_user && current_user.locale.to_s != I18n.locale.to_s
      current_user.update!(locale: I18n.locale)
    end
  end
end
