Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users, skip: [:registrations]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  authenticated :user do
    root to: "garments#index", as: :authenticated_root
  end

  unauthenticated do
    root to: "pages#home", as: :unauthenticated_root
  end

  namespace :admin do
    resources :garments, except: [:show] # Admin-only CRUD actions
  end

  resources :garments, only: [:index, :show] do
    member do
      post :purchase
    end
  end

  post '/create-checkout-session', to: 'payments#create_checkout_session'
  get '/session-status', to: 'payments#session_status'
  
  resources :pages
  resources :users, only: [:show]
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # Defines the root path route ("/")
  # root "posts#index"
end
