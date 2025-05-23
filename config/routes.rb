Rails.application.routes.draw do
  devise_for :users

  # Profiles
  resource :profile, only: [ :show, :edit, :update ]

  # Resources
  resources :projects do
    member do
      patch :archive
      patch :complete
    end
    resources :tasks, except: [ :index ] do
      member do
        patch :complete
        patch :update_checklist
      end
      resources :comments, only: [ :create, :edit, :update, :destroy ]
    end
  end

  # Root path
  root "home#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
