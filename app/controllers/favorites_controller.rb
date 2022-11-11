class FavoritesController < ApplicationController

    before_action :require_signin
    before_action :set_movie
    
    def create
        
        @movie.favorites.create!(user: current_user)

        redirect_to @movie, notice: "You have favorited this movie!"
    end

    def destroy
        favorite = current_user.favorites.find(params[:id])
        favorite.destroy

        @movie = Movie.find(params[:movie_id])
        redirect_to @movie, alert: "You have unfavorited this movie!"
    end

    private
    
    def set_movie
        @movie = Movie.find_by!(slug: params[:movie_id])
    end
end
