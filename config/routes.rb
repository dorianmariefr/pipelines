Rails.application.routes.draw do
  resource :session

  resources :users do
    resources :emails, shallow: true do
      post :send_verification
    end

    resources :phone_numbers, shallow: true do
      post :send_verification
    end

    resources :pipelines, only: :index
  end

  resources :pipelines

  root "pages#home"
end
