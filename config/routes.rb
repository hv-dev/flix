Rails.application.routes.draw do

  get "signup" => "users#new"

  resources :users
  root "movies#index"
    
  resources :movies do
    resources :reviews
    resources :favorites, only: [:create, :destroy]
  end

  get "signin" => "sessions#new"

  resource :session, only: [:new, :create, :destroy] 

end
