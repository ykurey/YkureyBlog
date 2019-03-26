class Article < ApplicationRecord
  belongs_to :user
  mount_uploader :image, ImageUploader


  extend FriendlyId
  friendly_id :title, use: :slugged

  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize.to_s
  end

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  def self.search_title(date, date1)
    where("user_id = ? and title Like ?", date, date1)
  end

  def self.back_page(date, date1, date2)
    where("user_id = ? and id < ? ", date, date1).order(date2).last
  end

  def self.next_page(date, date1, date2)
    where("user_id = ? and id > ? ", date, date1).order(date2).first
  end

end
