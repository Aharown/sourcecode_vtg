Rails.application.routes.draw do
  get 'static_pages/shipping'
  get 'static_pages/contact'
  get 'static_pages/terms'
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
    resources :garments, only: [:new, :create, :edit, :update]
  end

  resources :garments, only: [:index, :show, :new, :edit, :create, :destroy, :update] do
    member do
      post :purchase
      patch :toggle_new_in
    end
    collection do
      patch :clear_new_in
    end
  end

  post '/create-checkout-session', to: 'payments#create_checkout_session'
  post '/webhooks/stripe', to: 'webhooks#stripe'
  get '/checkout', to: 'garments#checkout'
  get '/session-status', to: 'payments#session_status'
  get '/thank_you', to: 'payments#thank_you', as: :thank_you
  get 'checkout', to: 'checkout#show'

  get "/shipping", to: "static_pages#shipping", as: :shipping
  get "/contact",  to: "static_pages#contact",  as: :contact
  get "/terms",    to: "static_pages#terms",    as: :terms

  resources :pages
  resources :users, only: [:show]
  resource :cart, only: [:show]
  resources :cart_items, only: [:create, :update, :destroy]
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # Defines the root path route ("/")
  # root "posts#index"
end
