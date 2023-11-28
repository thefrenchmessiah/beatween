class AlbumsController < ApplicationController
  require 'rest-client'
  require 'json'

  before_action :get_key

  def show
    @album = "2WT1pbYjLJciAR26yMebkH?si=9HU9lX21R7ehUYAOQK9Arw"
    endpoint1 = RestClient.get(
      "https://api.spotify.com/v1/albums/#{@album}",
      headers = { 'Authorization': "Bearer #{@access_token}" }
    )
    @data = JSON.parse(endpoint1)
    @album_name = @data['name']
    @album_artist = @data['artists'['name ']]
    @release_date = @data['release_date']
    @parsed_release_date = DateTime.parse(@release_date) rescue nil
    @image = @data['url']
    @popularity = @data['popularity']
    @total_tracks = @data['total_tracks']
    @genre = @data['genres']
    total_duration_ms = @data['tracks']['items'].sum { |track| track['duration_ms'] }
    total_seconds = total_duration_ms / 1000
    minutes = total_seconds / 60
    seconds = total_seconds % 60
    @formatted_duration = "#{minutes}:#{seconds} min"
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
