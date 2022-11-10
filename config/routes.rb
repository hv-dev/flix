Rails.application.routes.draw do
  resources :genres

  get "signup" => "users#new"

  resources :users
  root "movies#index"

  get "movies/filter/:filter" => "movies#index", as: :filtered_movies


  resources :movies do
    resources :reviews
    resources :favorites, only: [:create, :destroy]
  end

  get "signin" => "sessions#new"

  resource :session, only: [:new, :create, :destroy] 

end
