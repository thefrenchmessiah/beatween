class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  before_action :get_key
  require 'rspotify/oauth'
  require 'rest-client'

  def home
    user_top_tracks
    top_fifty = RSpotify::Playlist.find("spotifycharts", "37i9dQZEVXbMDoHDwVN2tF")
    @top_fifty_tracks = top_fifty.tracks
    # endpoint1 = RestClient.get(
    #   "https://api.spotify.com/v1/artists/3ifxHfYz2pqHku0bwx8H5J?si=rRd3U9grQJG3Vgdjn8k0oA",
    #   headers={ 'Authorization': "Bearer #{@access_token}" }
    # )
    # @data1 = JSON.parse(endpoint1)
  end

  def user_top_tracks
    @user= current_user
    @user_spot = RSpotify::User.new(@user.spotify_auth)
    @user_top_tracks = @user_spot.top_tracks(limit: 20)
  end

  def discover
    @user = current_user
    # Pass this whenever we need to access the user's spotify account
    @spotify_user = RSpotify::User.new(@user.spotify_auth)
    # Check if token is expired
    if Time.at(current_user.spotify_auth['credentials']['expires_at']) < Time.current
      refresh_spotify_token(current_user)
    end
  end

  private
  def get_key
    response = RestClient.post 'https://accounts.spotify.com/api/token',
    { grant_type: 'client_credentials',
      client_id: ENV['CLIENT_ID'],
      client_secret: ENV['CLIENT_SECRET'] },
    { content_type: :json, accept: :json }

    @access_token = JSON.parse(response.body)['access_token']
  end


  def refresh_spotify_token(user)
    body = {
      grant_type: 'refresh_token',
      refresh_token: user.spotify_auth['credentials']['refresh_token'],
      client_id: ENV['CLIENT_ID'] ,
      client_secret: ENV['CLIENT_SECRET']
    }
    response = RestClient.post('https://accounts.spotify.com/api/token', body)
    auth_params = JSON.parse(response.body)
    user.spotify_auth['credentials'].update(
      'token'=> auth_params['access_token'],
      'expires_at'=> Time.current + auth_params['expires_in'].seconds
    )
  end
end
