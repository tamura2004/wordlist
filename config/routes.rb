Rails.application.routes.draw do

  resources :words do
    collection do
      post :upload
      get :maintenance
      get :plot
      get :total_rank
      get :monthly_rank
      get :weekly_rank
    end
  end

  get "login" => "sessions#new", as: :login
  post "session" => "sessions#create", as: :session
  delete "session" => "sessions#destroy"

  root "words#index"

end
