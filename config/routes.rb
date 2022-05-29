Rails.application.routes.draw do
  resource :session

  resources :users do
    resources :emails, shallow: true
    resources :phone_numbers, shallow: true
  end

  root "pages#home"
end
