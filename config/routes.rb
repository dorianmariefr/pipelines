Rails.application.routes.draw do
  resource :session do
    post "reset"
  end

  get "auth/:provider/callback", to: "sessions#create"

  resources :users do
    resource :password, only: %i[edit update] do
    end

    resources :emails, shallow: true do
      post :send_verification
    end

    resources :phone_numbers, shallow: true do
      post :send_verification
    end

    resources :pipelines, only: :index
  end

  resources :pipelines do
    post :process_now
  end

  get "privacy" => "pages#privacy"
  get "terms" => "pages#terms"

  root "pages#home"
end
