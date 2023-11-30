class AddPlaylistIdToMatches < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :playlist_id, :string
  end
end
