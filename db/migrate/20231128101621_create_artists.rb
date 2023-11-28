class CreateArtists < ActiveRecord::Migration[7.1]
  def change
    create_table :artists do |t|

      t.timestamps
    end
  end
end
