class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  before_action :get_key

  # log into spotify
  # def spotify_auth
  #   client_id = ENV['CLIENT_ID']
  #   redirect_uri = "https://beatween-e1ae66294d65.herokuapp.com/"
  #   scope = "playlist-read-private user-read-email"
  #   # state = "your_unique_state_value" # optional

  #   spotify_auth_url = "https://accounts.spotify.com/authorize?response_type=code&client_id=#{client_id}&redirect_uri=#{ERB::Util.url_encode(redirect_uri)}&scope=#{ERB::Util.url_encode(scope)}" #&state=#{state}

  #   redirect_to spotify_auth_url, allow_other_host: true
  # end

  def home
    endpoint1 = RestClient.get(
      "https://api.spotify.com/v1/artists/3ifxHfYz2pqHku0bwx8H5J?si=rRd3U9grQJG3Vgdjn8k0oA",
      headers={ 'Authorization': "Bearer #{@access_token}" }
    )
    @data1 = JSON.parse(endpoint1)

    @artist_name = @data1['name']
    @artist_popularity = @data1['popularity']
    @artist_followers = @data1['followers']['total']
  end

  def match
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
