class Playlist < ApplicationRecord
  belongs_to :generator, class_name: 'User'
end
