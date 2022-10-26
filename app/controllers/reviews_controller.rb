class ReviewsController < ApplicationController

    before_action :set_movie                                                                                                                                                                  

    def index
        @reviews = @movie.reviews
    end

    def new
        @review = @movie.reviews.new
    end

    def create
        @review = @movie.reviews.new(review_params)

        if @review.save
            redirect_to @movie, notice: "Movie successfully created!"
        else
            render :new, status: :unprocessable_entity 
        end
    end

    private

    def set_movie
        @movie = Movie.find(params[:movie_id])
    end
end
