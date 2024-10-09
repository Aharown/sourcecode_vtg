Rails.application.routes.draw do
  get 'reviews/index'
  get 'reviews/show'
  get 'reviews/new'
  get 'reviews/create'
  get 'reviews/destroy'
  get 'bookings/index'
  get 'bookings/show'
  get 'bookings/create'
  get 'bookings/destroy'
  get 'garments/index'
  get 'garments/show'
  get 'garments/new'
  get 'garments/create'
  get 'garments/edit'
  get 'garments/update'
  get 'garments/destroy'
  devise_for :users
  root "garments#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
