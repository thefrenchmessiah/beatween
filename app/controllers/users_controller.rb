class UsersController < ApplicationController
  require 'rspotify/oauth'
  require 'rest-client'
  require 'base64'
  require 'uri'

  def spotify
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    # We pass grab the user's spotify credentials as a hash and pass
    spotify_auth = spotify_user.to_hash
    # TODO: create the link between the page user and the spotify_auth hash
    # This will mean we need to access to spotify first I believe, maybe we can just link it
    @user = current_user.link_to_spotify(spotify_user, spotify_auth)
    # Redirects, even if not successfull jsut testingg
    redirect_to user_path(@user)
  end

  def show

    if Time.at(current_user.spotify_auth['credentials']['expires_at']) < Time.current
      refresh_spotify_token(current_user)
    end

    @user = User.find(params[:id])
    # Pass this whenever we need to access the user's spotify account
    @spotify_user = RSpotify::User.new(@user.spotify_auth)

    @top_artists = Rails.cache.fetch("#{@user.id}/top_artists", expires_in: 12.hours) do
      @spotify_user.top_artists
    end

    @top_tracks = Rails.cache.fetch("#{@user.id}/top_tracks", expires_in: 12.hours) do
      @spotify_user.top_tracks(time_range: 'long_term', limit: 50)
    end

    @total_duration_minutes = Rails.cache.fetch("#{@user.id}/total_duration_minutes", expires_in: 12.hours) do
      @top_tracks.sum { |track| track.duration_ms.to_i / 60000 } * 150
    end

    @total_liked_songs = Rails.cache.fetch("#{@user.id}/total_liked_songs", expires_in: 12.hours) do
      total_saved_tracks
    end

    # users saved tracks
    @saved_tracks = @spotify_user.saved_tracks(limit: 10)

    # users playlists
    @playlists = @spotify_user.playlists(limit: 10)

    # users recently played
    @recently_played = @spotify_user.recently_played(limit: 10)

    # follows
    # @follow = Follow.new
  end

  private


  def refresh_spotify_token(user)
    body = URI.encode_www_form({
      grant_type: 'refresh_token',
      refresh_token: user.spotify_auth['credentials']['refresh_token']
    })

    auth_header = "Basic " + Base64.strict_encode64("#{ENV['CLIENT_ID']}:#{ENV['CLIENT_SECRET']}")

    begin
      response = RestClient.post('https://accounts.spotify.com/api/token', body, {Authorization: auth_header, content_type: 'application/x-www-form-urlencoded'})
      auth_params = JSON.parse(response.body)

      user.spotify_auth['credentials'].update(
        'token'=> auth_params['access_token'],
        'expires_at'=> Time.current + auth_params['expires_in'].seconds
      )
    rescue RestClient::BadRequest => e
      puts "Bad request error: #{e.message}"
      puts "Response body: #{e.response.body}"
    end
  end

  def total_saved_tracks
    limit = 50
    offset = 0
    total_count = 0

    loop do
      saved_tracks = @spotify_user.saved_tracks(limit: limit, offset: offset)
      total_count += saved_tracks.count

      break if saved_tracks.count < limit || total_count >= 100

      offset += limit
    end
    total_count
  end
end
