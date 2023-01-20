require "sidekiq/web"
require "sidekiq/cron/web"

class AdminOnlyConstraint
  def matches?(request)
    return false unless request.session[:user_id]
    User.find_by(id: request.session[:user_id])&.admin?
  end
end

Rails.application.routes.draw do
  constraints(AdminOnlyConstraint.new) do
    namespace :admin do
      mount Sidekiq::Web => "/sidekiq"

      resources :users do
        post "impersonate"

        resources :pipelines, only: :index
      end

      resources :emails do
        post :send_verification
      end

      resources :phone_numbers do
        post :send_verification
      end

      resources :pipelines
    end
  end

  resource :session do
    post "reset"
  end

  get "auth/:provider/callback", to: "sessions#create"

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
    post :duplicate

    resources :items, only: :index do
      delete :destroy_all, on: :collection
    end
  end

  post "sources/preview" => "sources#preview"

  resources :items

  resources :posts do
    post :send_later
  end

  get "privacy" => "pages#privacy"
  get "terms" => "pages#terms"

  root "pages#home"
end
