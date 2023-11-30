class User < ApplicationRecord
  has_one :qr_code
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def link_to_spotify(spotify_user, spotify_auth)
    self.display_name = spotify_user.display_name
    self.spotify_auth = spotify_auth
    self.spotify_id = spotify_user.id
    self.spotify_url = spotify_user.external_urls["spotify"]
    self.image_url = spotify_user.images[0]["url"] if spotify_user.images.any?
    save! ? self : nil
  end

  def spotify_user
    RSpotify::User.new(spotify_auth)
  end
end
