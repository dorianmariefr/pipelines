require "sidekiq/web"
require "sidekiq/cron/web"

class AdminOnlyConstraint
  def matches?(request)
    return false unless request.session[:user_id]
    User.find_by(id: request.session[:user_id])&.admin?
  end
end

Rails.application.routes.draw do
  constraints(AdminOnlyConstraint.new) { mount Sidekiq::Web => "/sidekiq" }

  resource :session do
    post "reset"
  end

  get "auth/:provider/callback", to: "sessions#create"

  resources :accounts do
    get "mastodon/callback" => "accounts#callback", :on => :collection
    get "twitter/callback" => "accounts#callback", :on => :collection
    get "authorize" => "accounts#redirect_authorize"
  end

  resources :users do
    resource :password, only: %i[edit update]
    resources :phone_numbers, only: :index
    resources :pipelines, only: :index
  end

  resources :emails do
    post :send_verification
  end

  resources :phone_numbers do
    post :send_verification
  end

  resources :pipelines do
    post :process_now
    get :duplicate

    resources :items, only: :index do
      delete :destroy_all, on: :collection
    end
  end

  resources :items

  resources :posts do
    post :send_later
  end

  get "privacy" => "pages#privacy"
  get "terms" => "pages#terms"

  root "pages#home"
end
