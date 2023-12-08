class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  # before_action :get_key
  require 'rspotify/oauth'
  require 'rest-client'
  require 'base64'
  require 'uri'

  def home
    @user = current_user
    if @user && @user.spotify_auth && @user.spotify_auth['credentials'] && @user.spotify_auth['credentials']['token']
      # Check if token is expired
      if Time.at(current_user.spotify_auth['credentials']['expires_at']) < Time.current
        refresh_spotify_token(current_user)
      end

      # Pass this whenever we need to access the user's spotify account
      @spotify_user = RSpotify::User.new(@user.spotify_auth)
      user_top_listens
      friends_top_listens
    end
    top_fifty = RSpotify::Playlist.find("spotifycharts", "37i9dQZEVXbMDoHDwVN2tF")
    @top_fifty_tracks = top_fifty.tracks(limit: 8)
    @top_fifty_artists = top_fifty.tracks(limit: 8).map(&:artists).flatten.uniq
  end

  def user_top_listens
    @user = current_user
    if !@user.nil?
      if @user.spotify_auth &&
        @user_spot = RSpotify::User.new(@user.spotify_auth)

        @user_top_tracks = Rails.cache.fetch("#{@user.id}/top_tracks", expires_in: 12.hours) do
          @user_spot.top_tracks(limit: 8, time_range: 'short_term')
        end

        @user_top_artists = Rails.cache.fetch("#{@user.id}/top_artists", expires_in: 12.hours) do
          @user_spot.top_artists(limit: 8, time_range: 'short_term')
        end

        @user_top_albums = Rails.cache.fetch("#{@user.id}/top_albums", expires_in: 12.hours) do
          @user_spot.saved_albums(limit: 8)
        end
      end
    end
  end

  def friends_top_listens
    @user = current_user
    if !@user.nil?
      if @user.spotify_auth
        @user = current_user
        @followed_users = @user.following_users
        @friends_top_tracks = []
        @friends_top_artists = []
        @friends_top_albums = []
        @friends_names = []
        @followed_users.each do |user|
          @friends_names << user.display_name
          @friend_spotify = RSpotify::User.find(user.spotify_id)

          @friends_top_tracks << Rails.cache.fetch("#{user.id}/top_tracks", expires_in: 12.hours) do
            @friend_spotify.top_tracks(limit: 10, time_range: 'short_term')
          end

          @friends_top_artists << Rails.cache.fetch("#{user.id}/top_artists", expires_in: 12.hours) do
            @friend_spotify.top_artists(limit: 10, time_range: 'short_term')
          end

          @friends_top_albums << Rails.cache.fetch("#{user.id}/top_albums", expires_in: 12.hours) do
            @friend_spotify.saved_albums(limit: 10)
          end
        end
      end
    end
  end

  def discover
    @user = current_user
    @new_releases = RSpotify::Album.new_releases(limit: 8)
    @trending_tracks = playlist = RSpotify::Playlist.find('Discover Weekly', '37i9dQZEVXcQ9COmYvdajy')
    @recommendations = []
    @spotify_user = RSpotify::User.new(@user.spotify_auth)
    recommended_tracks = [@spotify_user.top_tracks(limit: 5, time_range: 'medium_term')]
    track_ids = recommended_tracks.flat_map do |tracks|
      tracks.map(&:id)
    end
    @recommendations << RSpotify::Recommendations.generate(limit: 8, seed_tracks: track_ids)
    # Check if token is expired
    if Time.at(current_user.spotify_auth['credentials']['expires_at']) < Time.current
      refresh_spotify_token(current_user)
    end
    ## Actual page functionality
    query = params[:search].present? ? params[:search][:query] : ""
    if query.present?
      @artist_results = RSpotify::Artist.search(query, limit: 8)
      @track_results = RSpotify::Track.search(query, limit: 8)
      @album_results = RSpotify::Album.search(query, limit: 8)
      @playlist_results = RSpotify::Playlist.search(query, limit: 8)
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

    @qr_code.generate_qr_code(current_user)
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
end
