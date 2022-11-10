class GenresController < ApplicationController

    before_action :set_genre, except: [:index, :new, :create]

    def index
        @genres = Genre.all
    end

    def show
        @movies = @genre.movies
    end

    def new
        @genre = Genre.new
    end

    def create
        @genre = Genre.new(genre_params)

        if @genre.save
            redirect_to @genre, notice: "New Genre has been successfully created!"
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @genre.update(genre_params)
            redirect_to @genre, notice: "#{@genre.name} has been updated successfully!"
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @genre.destroy
        redirect_to genres_url, status: :see_other, alert: @genre.name + " has been deleted."
    end

    private
    
    def set_genre
        @genre = Genre.find_by!(name: params[:id].capitalize)
    end

    def genre_params
        params.require(:genre).permit(:name)
    end
end
