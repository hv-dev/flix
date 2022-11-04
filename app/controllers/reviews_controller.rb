class ReviewsController < ApplicationController

    before_action :require_signin, except: [:index]
    before_action :set_movie

    def index
        @reviews = @movie.reviews
    end

    def new
        @review = @movie.reviews.new
    end

    def create
        @review = @movie.reviews.new(review_params)
        @review.user = current_user

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

    def review_params
        params.require(:reivew).permit(:comment, :stars)
    end
end
