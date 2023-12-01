class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  before_action :get_key

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

  private
  def get_key
    response = RestClient.post 'https://accounts.spotify.com/api/token',
    { grant_type: 'client_credentials',
      client_id: ENV['CLIENT_ID'],
      client_secret: ENV['CLIENT_SECRET'] },
    { content_type: :json, accept: :json }

    @access_token = JSON.parse(response.body)['access_token']
  end
end
