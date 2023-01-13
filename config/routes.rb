Rails.application.routes.draw do
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

    resources :items, only: :index do
      delete :destroy_all, on: :collection
    end
  end

  resources :items

  get "privacy" => "pages#privacy"
  get "terms" => "pages#terms"

  root "pages#home"
end
