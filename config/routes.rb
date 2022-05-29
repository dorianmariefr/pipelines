Rails.application.routes.draw do
  resources :users
  resource :session

  root "pages#home"
end
