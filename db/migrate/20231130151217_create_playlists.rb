class CreatePlaylists < ActiveRecord::Migration[7.1]
  def change
    create_table :playlists do |t|
      t.references :generator, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
