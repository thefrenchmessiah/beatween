class ModifyForeignKeyForMessages < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :messages, :chatrooms
    add_foreign_key :messages, :chatrooms, on_delete: :cascade
  end
end
