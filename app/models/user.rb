class User < ApplicationRecord
  require "rqrcode"
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

  # def display_name
  #   return @user.display_name if @user.display_name
  # end

  # def generate_qr_code
  #   data = Rails.application.routes.url_helpers.user_url(self, host: 'https://www.beatween.us')
  #   qr = RQRCode::QRCode.new(data, size: 10, level: :h)

  #   svg = qr.as_svg(
  #     offset: 0,
  #     color: 'black',
  #     shape_rendering: 'crispEdges',
  #     module_size: 3
  #   )

  #   svg.html_safe
  # end
end
