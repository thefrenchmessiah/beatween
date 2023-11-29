require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV["CLIENT_ID"], ENV["CLIENT_SECRET"], scope: 'user-read-email playlist-modify-public user-library-read user-library-modify user-follow-read user-top-read user-read-recently-played user-library-read user-read-currently-playing playlist-read-collaborative'
end

OmniAuth.config.allowed_request_methods = [:post, :get]
