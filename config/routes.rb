Rails.application.routes.draw do
  resources :words do
    collection do
      post :upload
    end
  end

  resource :session
  root "words#index"
end
