class AddHeaderImageToUsersInformationsTable < ActiveRecord::Migration[5.2]
  def change
    add_column :users_informations, :header_image, :string
  end
end
