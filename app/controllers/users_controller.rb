class UsersController < ApplicationController
  require 'rest-client'
  require 'json'

  before_action :set_user

  def show
    # Show top user tracks

    endpoint1 = RestClient.get(
      "https://api.spotify.com/v1/me",
      headers={ 'Authorization': "Bearer #{@access_token}" }
    )
    @data1 = JSON.parse(endpoint1)

    @user_name = @data1['display_name']
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def get_key
    response = RestClient.post 'https://accounts.spotify.com/api/token',
    { grant_type: 'client_credentials',
      client_id: ENV['CLIENT_ID'],
      client_secret: ENV['CLIENT_SECRET'] },
    { content_type: :json, accept: :json }

    access_token = JSON.parse(response.body)['access_token']
  end
end
