class RemoveUsersIdInUsersInformationsTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :users_informations, :users_id
    add_column :users_informations, :user_id, :integer
    add_index :users_informations, :user_id
  end
end
