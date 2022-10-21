class Movie < ApplicationRecord

    RATINGS = %w(G PG PG-13 R NC-17)

    validates :title, :released_on, :duration, presence: true

    validates :description, length: { minimum: 25 }

    validates :total_gross, numericality: { greater_then_or_equal_to: 0 }

    validates :image_file_name, format: {
                                with: /\w+\.(jpg|png)\z/i,
                                message: "must be a JPG or PNG image"
                                }

    validates :rating, inclusion: { in: RATINGS }

    def self.released
        where("released_on < ?", Time.now).order(released_on: :desc)
    end

    def flop?
        self.total_gross < 225000000
    end
end
