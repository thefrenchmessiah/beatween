class TracksController < ApplicationController
  require 'open-uri'
  require 'rest-client'
  require 'json'
  require 'erb'

  before_action :get_key

  # https://api.spotify.com/v1/browse/categories/{category_id}/playlists
  
  def index

  end

  def show
    @track = "0bYg9bo50gSsH3LtXe2SQn?si=c9d8cbfa5566461c"
    endpoint1 = RestClient.get(
      "https://api.spotify.com/v1/tracks/#{@track}",
      headers={ 'Authorization': "Bearer #{@access_token}" }
    )
  endpoint2 = RestClient.get(
    "https://api.spotify.com/v1/audio-features/#{@track}",
      headers={ 'Authorization': "Bearer #{@access_token}" }
  )

    @data1 = JSON.parse(endpoint1)
    @data2 = JSON.parse(endpoint2)


    # ---- song infos ----
    @song_name = @data1['name']    
    @song_popularity = @data1['popularity']
    @song_length = @data1['duration_ms']/60000
    # ---- audio features ----
    @song_valence = @data2['valence']
    @song_danceability = @data2['danceability']
    @song_energy = @data2['energy']


    @artist_name = @data1['artists'][0]['name']
    # @album_name = @data1['album']['name']
    # @albun_link= @data1['album']['uri']
    @album_image = @data1['album']['images'][0]['url']
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
