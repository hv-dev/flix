class Review < ApplicationRecord
  STARS = [1,2,3,4,5]

  validates :name, presence: true
  validates :comment, length: { minimum: 4 }
  validates :rating, inclusion: { in: STARS, message: "Should be between 1 and 5" }

  belongs_to :movie
end
