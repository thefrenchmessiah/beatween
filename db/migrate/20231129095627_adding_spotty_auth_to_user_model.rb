class AddingSpottyAuthToUserModel < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :spotify_auth, :jsonb
  end
end
