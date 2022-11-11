class User < ApplicationRecord
  has_secure_password

  before_save :format_email
  before_save :format_username

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

  validates :name, presence: true
  validates :username, presence: true, format: { with: /\A[A-Z0-9]+\z/i, message: "Must be a valid username"}, uniqueness: { case_sensitive: false }
  validates :email, presence: true,
    format: { with: /\S+@\S+/, message: "Must be a valid email"}, 
    uniqueness: { case_sensitive: false }

  scope :by_name, -> { order(:name) }
  scope :not_admins, -> { where(admin: false).order(:name) }
  scope :admin, -> { where("admin == true > ?").order(:name) }

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  def to_param
    username
  end

  private

  def format_email
    self.email = email.downcase
  end

  def format_username
    self.username = username.downcase
  end
end
