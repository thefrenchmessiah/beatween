Rails.application.routes.draw do
  devise_for :users
  root to: "pages#landing"
  # root to: 'users#spotify'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/auth/spotify/callback', to: 'users#spotify'
  get '/users/spotify', as: 'spotify_login'
  get 'discover', to: 'pages#discover'


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources "users" do
    resources "matches", only: [:index, :show, :create]
  end

  resources "tracks"
  resources "albums"
  resources "artists"
  resources "playlists"
end
