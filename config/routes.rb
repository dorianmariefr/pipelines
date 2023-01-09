Rails.application.routes.draw do
  resource :session do
    post "reset"
  end

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

  root "pages#home"
end
