class MatchesController < ApplicationController
  require 'rspotify/oauth'
  before_action :set_users

  ## ORDER OF THINGS BC THIS SHIT IS CONFUSING
  # 1. set the generator and the buddy with set_users
  # 2. create shared artists and shared tracks methods
  # 3. call those methods in index to show shared artists and tracks
  # 4. create match (one match is one playlist between generator and buddy)
  #   4.1 call shared tracks and artists methods
  #   4.2 generate recommendations based on top 2 shared tracks and artists
  #   4.3 create playlist on spotify
  #   4.3 add essentail params to match instance and save it
  # 5. call match and find the playlist in spotify and show it in show page

  def index
    unless @spotify_generator.images[0].nil?
      @generator_image = @spotify_generator.images[0]['url']
    end
    unless @spotify_buddy.images[0].nil?
      @buddy_image = @spotify_buddy.images[0]['url']
    end

    shared_artists
    shared_tracks
  end

  def show
    @match = Match.find(params[:id])
    @playlist = RSpotify::Playlist.find(current_user.spotify_auth[:id], @match.playlist_id)
  end

  def create
    @match = Match.new

    shared_artists
    shared_tracks

    shared_artist_ids = @shared_artists.map { |artist| artist[:id] }.first(2)
    shared_track_ids = @shared_tracks.map { |track| track[:id] }.first(2)

    puts "Artist IDs: #{shared_artist_ids}"
    puts "Track IDs: #{shared_track_ids}"

    recommendations = RSpotify::Recommendations.generate(limit: 50, seed_tracks: shared_track_ids, seed_artists: shared_artist_ids)
    recommended_tracks = recommendations.tracks
    @playlist = @spotify_generator.create_playlist!("#{@generator.display_name} + #{@buddy.display_name}")
    @playlist.add_tracks!(recommended_tracks)
    @playlist_id = @playlist.id

    @match.generator_id = @generator.id
    @match.buddy_id = @buddy.id
    @match.playlist_id = @playlist_id

    @match.save!
    redirect_to user_match_path(current_user, @match)
  end

  private

  def shared_artists
    generator_top_artists = @spotify_generator.top_artists(limit: 20)
    buddy_top_artists = @spotify_buddy.top_artists(limit: 20)

    shared_artist_ids = generator_top_artists.map(&:id) & buddy_top_artists.map(&:id)
    @shared_artists = shared_artist_ids.map do |id|
      artist = RSpotify::Artist.find(id)
      {
        name: artist.name,
        id: artist.id,
        image_url: artist.images[0]['url'] # Assuming the artist has images
      }
    end
  end

  def shared_tracks
    generator_top_tracks = @spotify_generator.top_tracks(limit: 20)
    buddy_top_tracks = @spotify_buddy.top_tracks(limit: 20)

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

  def set_users
    @generator = current_user
    @spotify_generator = RSpotify::User.new(@generator.spotify_auth)
    @buddy = User.find(params[:user_id])
    @spotify_buddy = RSpotify::User.new(@buddy.spotify_auth)
  end
end
