class FixAboutInUsersInformationsTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :users_informations, :about
    add_column :users_informations, :about, :text
    add_column :users_informations, :phone, :decimal
  end
end
