class Article < ApplicationRecord
  belongs_to :user
  mount_uploader :image, ImageUploader


  extend FriendlyId
  friendly_id :title, use: :slugged

  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize.to_s
  end

end
