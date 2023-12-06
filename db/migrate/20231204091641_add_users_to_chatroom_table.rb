class AddUsersToChatroomTable < ActiveRecord::Migration[7.1]
  def change
    add_reference :chatrooms, :generator, null: false, foreign_key: { to_table: :users }
    add_reference :chatrooms, :buddy, null: false, foreign_key: { to_table: :users }
  end
end
