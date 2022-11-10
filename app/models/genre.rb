class Genre < ApplicationRecord

    before_save :format_genre

    has_many :characterizations, dependent: :destroy
    has_many :movies, through: :characterizations

    validates :name, presence: true, uniqueness: true

    def to_param
        name.downcase
    end

    private

    def format_genre
        self.name = name.capitalize
    end
end
