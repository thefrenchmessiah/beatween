class UsersController < ApplicationController
  require 'rspotify/oauth'
  require 'rest-client'

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

  def refresh_spotify_token(user)
    callback_proc = Proc.new { |new_access_token, token_lifetime |
      now = Time.now.utc.to_i  # seconds since 1/1/1970, midnight UTC
      deadline = now+token_lifetime
      #puts("new access token will expire at #{Time.at(deadline).utc.to_s}")
      self.save_new_access_token(new_access_token)
    }

    @spotify_user = RSpotify::User.new(
      {
        'credentials' => {
          "token" => user.spotify_auth["access_token"],
          "refresh_token" => user.spotify_auth["refresh_token"],
          "access_refresh_callback" => callback_proc
        } ,
        'id' => user.spotify_auth["user_id"]
      }
    )
  end

  def show
    @user = User.find(params[:id])
    # Pass this whenever we need to access the user's spotify account
    @spotify_user = RSpotify::User.new(@user.spotify_auth)
    # matches = Match.where(generator: @user)
    # buddies = Match.where(buddy: @user)

    if Time.at(current_user.spotify_auth['credentials']['expires_at']) < Time.current
      refresh_spotify_token(current_user)
    end

    @top_artists = @spotify_user.top_artists
    @top_tracks = @spotify_user.top_tracks

    # users all time listents
    @top_tracks = @spotify_user.top_tracks(time_range: 'long_term', limit: 50)
    @total_duration_minutes = @top_tracks.sum { |track| track.duration_ms.to_i / 60000 } * 150

    # Users liked songs (without limiting count)
    @total_liked_songs = total_saved_tracks

    # users saved tracks
    @saved_tracks = @spotify_user.saved_tracks(limit: 10)
  end

  private

  def total_saved_tracks
    limit = 50
    offset = 0
    total_count = 0

    loop do
      saved_tracks = @spotify_user.saved_tracks(limit: limit, offset: offset)
      total_count += saved_tracks.count

      break if saved_tracks.count < limit

      offset += limit
    end
    total_count
  end
end
