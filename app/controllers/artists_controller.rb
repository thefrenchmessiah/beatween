class ArtistsController < ApplicationController
  require 'open-uri'
  require 'rest-client'
  require 'json'
  require 'erb'
  require 'uri'
  require 'net/http'

  before_action :get_key

  def show
    @artist_id = "4iHNK0tOyZPYnBU7nGAgpQ?si=TmVgtD2OSXSOvBDsXEcX9g"
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
    # @ranking = @ranking["content"]["1"]["artist"]
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
        image: track.album.images.any? ? track.album.images.first['url'] : nil
      }
    end
    top_tracks_info
  end

  # def ranking
  #   url = URI("https://billboard-api2.p.rapidapi.com/artist-100?date=2023-11-30&range=1-100")

  #   http = Net::HTTP.new(url.host, url.port)
  #   http.use_ssl = true

  #   request = Net::HTTP::Get.new(url)
  #   request["X-RapidAPI-Key"] = '7628b4f9e5msh4326c1a97dab124p1a5949jsne5ca77cd4cba'
  #   request["X-RapidAPI-Host"] = 'billboard-api2.p.rapidapi.com'

  #   response = http.request(request)
  #   response = JSON.parse(response.read_body)
  # end
end
