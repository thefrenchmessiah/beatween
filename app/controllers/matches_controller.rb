class MatchesController < ApplicationController
  require 'rspotify/oauth'

  def index
    @generator = current_user
    # Pass this whenever we need to access the user's spotify account
    @spotify_generator = RSpotify::User.new(@generator.spotify_auth)
    @buddy = User.find(params[:user_id])
    @spotify_buddy = RSpotify::User.new(@buddy.spotify_auth)
  end

  # endpoint1 = RestClient.get(
  #   "https://api.spotify.com/v1/artists/4iHNK0tOyZPYnBU7nGAgpQ?si=1v21fDMzRjKRLTyoFyBZFA",
  #   headers={ 'Authorization': "Bearer #{@access_token}" }
  # )
  # @data1 = JSON.parse(endpoint1)

  # @maria = @data1['name']
  # @maria_photo = @data1['images'][0]['url']

  # endpoint2 = RestClient.get(
  #   "https://api.spotify.com/v1/artists/5lwmRuXgjX8xIwlnauTZIP?si=zA8LyXDLSVC65iuKFPiKmg",
  #   headers={ 'Authorization': "Bearer #{@access_token}" }
  # )
  # @data2 = JSON.parse(endpoint2)

  # @romeo = @data2['name']
  # @romeo_photo = @data2['images'][0]['url']
end
