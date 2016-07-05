Rails.application.routes.draw do

  scope :wl do
    resources :words do
      collection do
        post :upload
      end
    end

    resource :session
  end
  root "words#index"
end
