class PagesController < ApplicationController
  require 'open-uri'
  require 'rest-client'
  require 'json'

  skip_before_action :authenticate_user!, only: :home
  before_action :get_key

  def home
    @apikey = { 'Authorization': "Bearer BQB9XlbOSmMXIHgLKY70oY0txtSLsgXbBhOZbZAlIp_pt7P5EihIDOR95Y3KOwaeQOHBJ0nVGOrtDvlIznQ9XY5gzAxSKZY5zEu0pKLlfHh-RqEnZRU" }

    endpoint1 = RestClient.get(
      "https://api.spotify.com/v1/artists/3ifxHfYz2pqHku0bwx8H5J?si=rRd3U9grQJG3Vgdjn8k0oA",
      headers=@apikey
    )
    @data1 = JSON.parse(endpoint1)

    @artist_name = @data1['name']
    @artist_popularity = @data1['popularity']
    @artist_followers = @data1['followers']['total']
  end

  private

  def get_key
    response = RestClient.post 'https://accounts.spotify.com/api/token',
    { grant_type: 'client_credentials',
      client_id: ENV['CLIENT_ID'],
      client_secret: ENV['CLIENT_SECRET'] },
    { content_type: :json, accept: :json }

    access_token = JSON.parse(response.body)['access_token']
  end
end
