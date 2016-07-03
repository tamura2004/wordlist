Rails.application.routes.draw do
  resources :words
  resource :session
  root "words#index"
end
