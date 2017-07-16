Rails.application.routes.draw do

  scope :wordlist do
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

    resource :session
  end
  root "words#index"
  get "headers" => "words#headers"
end
