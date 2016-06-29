Rails.application.routes.draw do
  resources :users, only: [:none] do
    resources :password_resets, only: [:edit, :update]
  end
  resource :session, only: [:new, :create, :destroy]
  resources :password_resets, only: [:new, :create]
  resources :users, only: [:new, :create]
  resources :words
  root "words#index"
end
