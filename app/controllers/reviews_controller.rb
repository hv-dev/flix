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

    def destroy
        @review = @movie.reviews.find(params[:id])
        if @review.destroy
            redirect_to @review.user, notice: "Review successfully deleted!"
        else
            redirect_to @review.user, alert: "Unable to delete review."
        end
    end

    private

    def set_movie
        @movie = Movie.find_by!(slug: params[:movie_id])
    end

    def review_params
        params.require(:review).permit(:comment, :stars)
    end
end
