Rails.application.routes.draw do
  resource :session

  resources :users do
    resources :emails, shallow: true do
      post :send_verification
    end

    resources :phone_numbers, shallow: true
  end

  root "pages#home"
end
