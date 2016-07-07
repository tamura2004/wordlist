Rails.application.routes.draw do

  scope :wl do
    resources :words do
      collection do
        post :upload
        get :count
      end
    end

    resource :session
  end
  root "words#index"
end
