class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  # before_action :get_key
  require 'rspotify/oauth'
  require 'rest-client'

  def home
    @user = current_user
    if current_user.nil? == false && current_user.spotify_auth.nil? == false
      # Check if token is expired
      if Time.at(current_user.spotify_auth['credentials']['expires_at']) < Time.current
        refresh_spotify_token(current_user)
      end

      # Pass this whenever we need to access the user's spotify account
      @spotify_user = RSpotify::User.new(@user.spotify_auth)
      user_top_tracks
      buddies_top_tracks
    end
    top_fifty = RSpotify::Playlist.find("spotifycharts", "37i9dQZEVXbMDoHDwVN2tF")
    @top_fifty_tracks = top_fifty.tracks(limit: 10)
  end

  def user_top_tracks
    @user = current_user
    if !@user.nil?
      if @user.spotify_auth &&
        @user_spot = RSpotify::User.new(@user.spotify_auth)
        @user_top_tracks = @user_spot.top_tracks(limit: 10, time_range: 'short_term')
      end
    end
  end

  def buddies_top_tracks
    @user = current_user
    if !@user.nil?
      if @user.spotify_auth
        @user_spot = RSpotify::User.new(@user.spotify_auth)
        @buddies_top_tracks = @user_spot.top_tracks(limit: 10, time_range: 'long_term')
      end
    end
  end

  def discover
    @user = current_user
    @new_releases = RSpotify::Album.new_releases(limit: 10)
    @trending_tracks = playlist = RSpotify::Playlist.find('Discover Weekly', '37i9dQZEVXcQ9COmYvdajy')
    @recommendations = []
    @spotify_user = RSpotify::User.new(@user.spotify_auth)
    recommended_tracks = [@spotify_user.top_tracks(limit: 5, time_range: 'medium_term')]
    track_ids = recommended_tracks.flat_map do |tracks|
      tracks.map(&:id)
    end
    @recommendations << RSpotify::Recommendations.generate(limit: 10, seed_tracks: track_ids)
    # Check if token is expired
    if Time.at(current_user.spotify_auth['credentials']['expires_at']) < Time.current
      refresh_spotify_token(current_user)
    end
    ## Actual page functionality
    query = params[:search].present? ? params[:search][:query] : ""
    if query.present?
      @artist_results = RSpotify::Artist.search(query, limit: 10)
      @track_results = RSpotify::Track.search(query, limit: 20)
      @album_results = RSpotify::Album.search(query, limit: 10)
      @playlist_results = RSpotify::Playlist.search(query, limit: 10)
      ## passing params to the render partial
      render partial: 'results', locals: {
        artist_results: @artist_results,
        track_results: @track_results,
        album_results: @album_results,
        playlist_results: @playlist_results
      },
      formats: [:html]
    end
  end

  def qr_page
    @user = current_user
    @qr_code = QrCode.find_by(user: @user)

    if @qr_code.nil?
      @qr_code = QrCode.new(user: @user)
      @qr_code.save
    end

    @qr_code.generate_qr_code
  end

  private

  def refresh_spotify_token(user)
    body = {
      grant_type: 'refresh_token',
      refresh_token: user.spotify_auth['credentials']['refresh_token'],
      client_id: ENV['CLIENT_ID'] ,
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
