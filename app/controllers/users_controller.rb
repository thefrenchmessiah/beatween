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


    # Now you can access user's private data, create playlists and much more

    # # Access private data
    # @spotify_user.country #=> "US"
    # @spotify_user.email   #=> "example@email.com"

    # # Create playlist in user's Spotify account
    # @playlist = @spotify_user.create_playlist!('my-awesome-playlist')

    # # Add tracks to a playlist in user's Spotify account
    # @tracks = RSpotify::Track.search('Know')
    # @playlist.add_tracks!(tracks)
    # @playlist.tracks.first.name #=> "Somebody That I Used To Know"

    # # Access and modify user's music library
    # @spotify_user.save_tracks!(tracks)
    # @spotify_user.saved_tracks.size #=> 20
    # @spotify_user.remove_tracks!(tracks)

    # @albums = RSpotify::Album.search('launeddas')
    # @spotify_user.save_albums!(albums)
    # @spotify_user.saved_albums.size #=> 10
    # @spotify_user.remove_albums!(albums)

    # # Use Spotify Follow features
    # @spotify_user.follow(playlist)
    # # spotify_user.follows?(artists)
    # # spotify_user.unfollow(users)

    # # Get user's top played artists and tracks
    # @spotify_user.top_artists #=> (Artist array)
    # @spotify_user.top_tracks(time_range: 'short_term') #=> (Track array)

    # Check doc for more
    # @hash = @spotify_user.to_hash
  end
  # hash containing all user attributes, including access tokens

  # Use the hash to persist the data the way you prefer...

  # Then recover the Spotify user whenever you like
  # @spotify_user = RSpotify::User.new(hash)
  # spotify_user.create_playlist!('my_awesome_playlist') # automatically refreshes token
  def show
    @user = User.find(params[:id])
    # Pass this whenever we need to access the user's spotify account
    @spotify_user = RSpotify::User.new(@user.spotify_auth)
    # @matches = Match.where(generator: @user)
    # @buddies = Match.where(buddy: @user)

    @top_artists =  @spotify_user.top_artists
    @top_tracks =  @spotify_user.top_tracks
    # @top_tracks = @top_tracks[0..4]
    # @top_artist = @top_artist[0..4]
  end
end
