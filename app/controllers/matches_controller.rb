class MatchesController < ApplicationController
  require 'rspotify/oauth'
  before_action :set_users

  def index
    unless @spotify_generator.images[0].nil?
      @generator_image = @spotify_generator.images[0]['url']
    end
    unless @spotify_buddy.images[0].nil?
      @buddy_image = @spotify_buddy.images[0]['url']
    end

    generator_top_artists = @spotify_generator.top_artists(limit: 50)
    buddy_top_artists = @spotify_buddy.top_artists(limit: 50)

    shared_artist_ids = generator_top_artists.map(&:id) & buddy_top_artists.map(&:id)
    @shared_artists = shared_artist_ids.map do |id|
      artist = RSpotify::Artist.find(id)
      {
        name: artist.name,
        id: artist.id,
        image_url: artist.images[0]['url'] # Assuming the artist has images
      }
    end

    generator_top_tracks = @spotify_generator.top_tracks(limit: 50)
    buddy_top_tracks = @spotify_buddy.top_tracks(limit: 50)

    shared_tracks_ids = generator_top_tracks.map(&:id) & buddy_top_tracks.map(&:id)
    @shared_tracks = shared_tracks_ids.map do |id|
      track = RSpotify::Track.find(id)
      {
        name: track.name,
        id: track.id,
        image_url: track.album.images[0]['url'] # Assuming the track has images
      }
    end
  end

  def show
    @match = Match.find(params[:id])
    @match_playlist = @playlist
  end

  def new
    @match = Match.new
    recommendations = RSpotify::Recommendations.generate(limit: 50, seed_tracks: [@shared_tracks[:id].each], seed_artists: [@shared_artists[:id].each])
    recommended_tracks = recommendations.tracks
    @playlist = user.create_playlist!("#{@generator.display_name} + #{@buddy.display_name}")
    @playlist.add_tracks!(recommended_tracks)
  end

  def create
    @match = Match.new(match_params)
    if @match.save
      redirect_to user_matches_path(current_user)
    else
      render :new
    end
  end

  private

  def set_users
    @generator = current_user
    @spotify_generator = RSpotify::User.new(@generator.spotify_auth)
    @buddy = User.find(params[:user_id])
    @spotify_buddy = RSpotify::User.new(@buddy.spotify_auth)

    # generator_endpoint = RestClient.get(
    #   "https://api.spotify.com/v1/users/#{@spotify_generator.id}",
    #   headers={ 'Authorization': "Bearer #{@access_token}" }
    # )
    # @generator_data = JSON.parse(generator_endpoint)

    # buddy_endpoint = RestClient.get(
    #   "https://api.spotify.com/v1/users/#{@spotify_buddy.id}",
    #   headers={ 'Authorization': "Bearer #{@access_token}" }
    # )
    # @buddy_data = JSON.parse(buddy_endpoint)
  end
end
