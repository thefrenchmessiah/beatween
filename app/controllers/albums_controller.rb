class AlbumsController < ApplicationController
  require 'rest-client'
  require 'json'
  require 'rspotify/oauth'

  before_action :get_key, :get_user

  def show
    @album_id = params[:id]
    # @data = JSON.parse(endpoint1)
    album = RSpotify::Album.find(@album_id)
    @album_name = album.name
    # @album_name = @data['name']
    # @album_artist = @data['artists'['name ']]
    @artist = album.artists[0]
    @albums_by_artist = @artist.albums
    @album_artist = album.artists[0].name
    @user_albums = @spotify_user.saved_albums(limit: 3)
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

  def get_user
    @user = current_user
    # Pass this whenever we need to access the user's spotify account

    @spotify_user = RSpotify::User.new(@user.spotify_auth)

    if Time.at(current_user.spotify_auth['credentials']['expires_at']) < Time.current
      refresh_spotify_token(current_user)
    end
  end



  def refresh_spotify_token(user)
    body = {
      grant_type: 'refresh_token',
      refresh_token: user.spotify_auth['credentials']['refresh_token'],
      client_id: ENV['CLIENT_ID'],
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
