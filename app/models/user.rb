class User < ApplicationRecord

  # def to_param
  #     self.username
  #     #username
  # end

  has_many :articles

  attr_accessor :password
  before_save :encrypt_password
  #驗證兩個字段是否相等
  validates_confirmation_of :password
  #檢查資料為非 nil 或空字串
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  #檢查資料在資料表中必須唯一
  validates_uniqueness_of :email

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
