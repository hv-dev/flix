class Review < ApplicationRecord

  belongs_to :movie
  belongs_to :user

  STARS = [1,2,3,4,5]

  validates :comment, length: { minimum: 4 }
  validates :stars, inclusion: { in: STARS, message: "Should be between 1 and 5" }

  scope :past_n_days, lambda { |days| where("created_on >= ?", days.days.ago ) }
end
