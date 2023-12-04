class QrCode < ApplicationRecord
  belongs_to :user

  def generate_qr_code
    data = Rails.application.routes.url_helpers.user_url(self, host: 'https://beatween-e1ae66294d65.herokuapp.com/')
    qr = RQRCode::QRCode.new(data, size: 10, level: :h)

    svg = qr.as_svg(
      offset: 0,
      color: 'white',
      shape_rendering: 'auto',
      module_size: 5
    )

    svg.html_safe
  end
end
