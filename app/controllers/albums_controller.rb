class AlbumsController < ApplicationController
  require 'rest-client'
  require 'json'

  before_action :get_key

  def show
    @album_id = "4LH4d3cOWNNsVw41Gqt2kv"
    # @data = JSON.parse(endpoint1)
    album = RSpotify::Album.find(@album_id)
    @album_name = album.name
    # @album_name = @data['name']
    # @album_artist = @data['artists'['name ']]
    @album_artist = album.artists[0].name
    # @release_date = @data['release_date']
    @release_date = album.release_date
    @parsed_release_date = DateTime.parse(@release_date) rescue nil
    @album_image = album.images[0]['url']
    @popularity = album.popularity
    @total_tracks = album.total_tracks
    @genre = album.genres
    total_duration_ms = album.tracks.sum { |track| track.duration_ms }
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
