class AddSchoolToUsersInformationsTable < ActiveRecord::Migration[5.2]
  def change
    add_column :users_informations, :school, :string
  end
end
