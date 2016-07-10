Rails.application.routes.draw do

  scope :wordlist do
    resources :words do
      collection do
        post :upload
        get :maintenance
      end
    end

    resource :session
  end
  root "words#index"
end
