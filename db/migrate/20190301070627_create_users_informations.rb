class CreateUsersInformations < ActiveRecord::Migration[5.2]
  def change
    create_table :users_informations do |t|
      t.string :name
      t.string :birthday
      t.string :address
      t.string :email
      t.string :about
      t.string :image
      t.integer :users_id
      t.timestamps
    end
  end
end
