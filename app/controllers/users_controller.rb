class UsersController < ApplicationController
  require 'rspotify/oauth'

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

  def show
    @user = User.find(params[:id])
    # Pass this whenever we need to access the user's spotify account

    @spotify_user = RSpotify::User.new(@user.spotify_auth)
    # @matches = Match.where(generator: @user)
    # @buddies = Match.where(buddy: @user)

    if Time.at(current_user.spotify_auth['credentials']['expires_at']) < Time.current
      refresh_spotify_token(current_user)
    end
    @top_artists = @spotify_user.top_artists
    @top_tracks = @spotify_user.top_tracks
    # @top_tracks = @top_tracks[0..4]
    # @top_artist = @top_artist[0..4]
  end
end
