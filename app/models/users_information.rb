class UsersInformation < ApplicationRecord
  belongs_to :user
  mount_uploader :image, ImageUploader
  mount_uploader :header_image, ImageUploader
end
