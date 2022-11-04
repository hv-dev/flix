class MoviesController < ApplicationController

    before_action :require_signin, except: [:index, :show]
    before_action :require_admin, except: [:index, :show]

    def index
        @movies = Movie.released
    end

    def show
        @movie = Movie.find(params[:id])
        @fans = @movie.fans

        if current_user
            @favorite = current_user.favorites.find_by(movie_id: @movie.id)
        end
    end

    def edit
        @movie = Movie.find(params[:id])
    end

    def update
        @movie = Movie.find(params[:id])

        if @movie.update(movie_params)
            redirect_to @movie, notice: "Movie successfully updated!"
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def create
        @movie = Movie.find(params[:movie_id])
        @review = @movie.reviews.new(review_params)
      
        if @review.save
          redirect_to movie_reviews_path(@movie),
                        notice: "Thanks for your review!"
        else
          render :new, status: :unprocessable_entity
        end
    end 

    def new
        @movie = Movie.new
    end

    def destroy
        @movie = Movie.find(params[:id])
        title = @movie.title
        @movie.destroy

        redirect_to movies_url, status: :see_other, alert: title + " has been deleted."
    end

    private

    def movie_params
        params.require(:movie).permit(
            :title,
            :description,
            :rating,
            :released_on,
            :total_gross,
            :director,
            :duration,
            :image_file_name
        )
    end
end
