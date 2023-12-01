class PlaylistsController < ApplicationController
  # require 'rspotify/oauth'
  # before_action :set_users

  # def new
  #   @playlist = Playlist.new
  #   @generator_recommended_tracks = @spotify_generator.recommendations.tracks
  #   @buddy_recommended_tracks = @spotify_buddy.recommendations.tracks
  #   recommendations = RSpotify::Recommendations.generate(seed_tracks: ['0c6xIDDpzE81m2q797ordA'], seed_artists: ['4NHQUGzhtTLFvgF5SZesLK']
  # end
  def show
    @playlist_id = params[:id]
    @playlist_image = playlist.images[0]['url']

  end
end
