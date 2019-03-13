class AddSocialUrlToUsersInformationsTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :users_informations, :phone
    remove_column :users_informations, :address
    add_column :users_informations, :facebook, :text
    add_column :users_informations, :github, :text
    add_column :users_informations, :twitter, :text
    add_column :users_informations, :instagram, :text
  end
end
