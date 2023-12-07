Rails.application.routes.draw do
  devise_for :users
  mount ActionCable.server => '/cable'
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/auth/spotify/callback', to: 'users#spotify'
  get '/users/spotify', as: 'spotify_login'
  get 'discover', to: 'pages#discover'
  get 'qr_page', to: 'pages#qr_page', as: :qr_page
  delete '/users/:user_id/chatrooms/:id/destroy', to: 'chatrooms#destroy', as: :delete_chatroom

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources "users" do
    resources "chatrooms" do
      resources "messages"
    end
    resources "matches", only: [:index, :show, :create]
    resources "follows", only: [:index, :create, :destroy]
  end

  resources "tracks", only: [:show]
  resources "albums", only: [:show]
  resources "artists", only: [:show]

  # for all not found routes
  match "*path", to: "errors#not_found", via: :all
end
