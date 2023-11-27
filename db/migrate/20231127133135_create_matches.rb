class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.integer :compatibility_score
      t.references :generator, null: false, foreign_key: { to_table: :users }
      t.references :buddy, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
