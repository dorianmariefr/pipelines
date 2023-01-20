class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include CanConcern

  before_action :set_locale
  before_action :set_current
  before_action :update_locale

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  helper_method :current_user
  helper_method :can?

  rescue_from Pundit::NotAuthorizedError do |e|
    redirect_to root_path, alert: e.message
  end

  private

  def set_locale
    if params[:locale] &&
        I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]
      I18n.locale = params[:locale]
    elsif session[:locale] &&
        I18n.available_locales.include?(session[:locale].to_sym)
      I18n.locale = session[:locale]
    else
      I18n.locale =
        http_accept_language.compatible_language_from(I18n.available_locales)
    end
  end

  def set_current
    Current.user = current_user
  end

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def update_locale
    if current_user && current_user.locale != I18n.locale.to_s
      current_user.update!(locale: I18n.locale)
    end
  end
end
