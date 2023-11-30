class AddSpotifyIdAndTracksToPlaylists < ActiveRecord::Migration[7.1]
  def change
    add_column :playlists, :spotify_id, :string
    add_column :playlists, :tracks, :text
  end
end
