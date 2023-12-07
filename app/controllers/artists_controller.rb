class ArtistsController < ApplicationController
  require 'open-uri'
  require 'rest-client'
  require 'json'
  require 'erb'
  require 'uri'
  require 'net/http'

  before_action :get_key

  def show
    @artist_id = params[:id]
    @top_tracks = fetch_top_tracks(@artist_id)

    endpoint1 = RestClient.get(
      "https://api.spotify.com/v1/artists/#{@artist_id}",
      headers = { 'Authorization': "Bearer #{@access_token}" }
    )

    @data1 = JSON.parse(endpoint1)

    @artist_name = @data1['name']
    @artist_popularity = @data1['popularity']
    @artist_followers = @data1['followers']['total']
    @artist_image_url = @data1['images'][0]['url']
    @artist_genres = @data1['genres']
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

  def fetch_top_tracks(artist_spotify_id)
    artist = RSpotify::Artist.find(artist_spotify_id)
    top_tracks = artist.top_tracks('ES')
    top_tracks_info = top_tracks.map do |track|
      {
        name: track.name,
        image: track.album.images.any? ? track.album.images.first['url'] : nil,
        uri: track.uri.match(/spotify:track:(.*)/),
        duration_ms: track.duration_ms
      }
    end
    top_tracks_info
  end
end
