class Match < ApplicationRecord
  has_one :generator, class_name: 'User', foreign_key: :generator_id
  has_one :buddy, class_name: 'User', foreign_key: :buddy_id
end
