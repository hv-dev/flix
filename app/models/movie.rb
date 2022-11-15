class Movie < ApplicationRecord

    before_save :set_slug

    has_many :reviews, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :fans, through: :favorites, source: :user
    has_many :characterizations, dependent: :destroy
    has_many :genres, through: :characterizations

    RATINGS = %w(G PG PG-13 R NC-17)

    validates :title, presence: true, uniqueness: true
    
    validates :released_on, :duration, presence: true

    validates :description, length: { minimum: 25 }

    validates :total_gross, numericality: { greater_then_or_equal_to: 0 }

    validates :director, presence: true

    validates :rating, inclusion: { in: RATINGS }

    validate :acceptable_image


    has_one_attached :poster_image

    scope :released, -> { where("released_on < ?", Time.now).order("released_on desc") }
    scope :upcoming, -> { where("released_on > ?", Time.now).order("released_on asc") }
    scope :recent, lambda { |limit=5| released.limit(limit) }
    scope :flops, -> { released.where("total_gross < 22500000").order(total_gross: :asc) }
    scope :hits, -> { released.where("total_gross >= 300000000").order(total_gross: :desc) }
    scope :grossed_less_than, lambda { |max| released.where("total_gross < ?", max) }
    scope :grossed_greater_than, lambda { |min| released.where("total_gross > ?", min) }


    def flop?
        self.total_gross < 225000000
    end

    def average_stars
        reviews.average(:stars) || 0.0
    end

    def to_param
        slug
    end

    private

    def set_slug
        self.slug = title.parameterize
    end

    def acceptable_image
        return unless poster_image.attached?

        unless poster_image.blob.byte_size <= 1.megabyte
          errors.add(:poster_image, "must be smaller than 1 megabyte")
        end
      
        acceptable_types = ["image/jpeg", "image/png"]
        unless acceptable_types.include?(poster_image.content_type)
          errors.add(:poster_image, "must be a JPEG or PNG")
        end
    end
end
