class User < ApplicationRecord
  has_secure_password

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

  validates :name, presence: true
  validates :username, presence: true, format: { with: /\A[A-Z0-9]+\z/i, message: "Must be a valid username"}, uniqueness: { case_sensitive: false }
  validates :email, presence: true,
    format: { with: /\S+@\S+/, message: "Must be a valid email"}, 
    uniqueness: { case_sensitive: false }

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end
end
