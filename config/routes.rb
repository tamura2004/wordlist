Rails.application.routes.draw do

  scope :wordlist do
    resources :words do
      collection do
        post :upload
        get :count
        get :maintenance
      end
    end

    resource :session
  end
  root "words#index"
end
