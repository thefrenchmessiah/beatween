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

    @hash = spotify_user.to_hash
    # # hash containing all user attributes, including access tokens
    # # Use the hash to persist the data the way you prefer...
    # # Then recover the Spotify user whenever you like
    # @spotify_user = RSpotify::User.new(hash)
  end

  def show
    @user = User.find(params[:id])

    @spotify_user = RSpotify::User.new(@user.spotify_auth)

    @top_artists = @spotify_user.top_artists
    @top_tracks = @spotify_user.top_tracks
  end
end
