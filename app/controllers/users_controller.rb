class UsersController < ApplicationController

    before_action :set_user, only: [:show, :destroy]
    before_action :require_signin, except: [:new, :create]
    before_action :require_correct_user, only: [:edit, :update]
    before_action :require_correct_user_or_admin, only: [:destroy]

    def index
        @users = User.not_admins
    end

    def show
        @reviews = @user.reviews
        @favorites = @user.favorite_movies
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        
        if @user.save
            session[:user_id] = @user.id
            redirect_to (session[:intended_url] || @user),
                   notice: "Welcome back, #{@user.name}!"
            session[:intended_url] = nil
        else
            flash.now[:alert] = "Invalid Email/Password Combination"
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @user.update(user_params)
            redirect_to @user, notice: "Account successfuly updated!"
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        if session[:user_id] = @user.id
            session[:user_id] = nil
        end

        @user.destroy

        redirect_to root_url, status: :see_other, alert: "Account successfuly deleted!"
    end

    private

    def set_user
        @user = User.find_by!(username: params[:id])
    end

    def user_params
        params.require(:user).permit(
            :name,
            :username,
            :email,
            :password,
            :password_confirmation
        )
    end

    def require_correct_user
        set_user
        redirect_to root_url, status: :see_other, alert: "You do not have access to that page, redirected to homepage." unless current_user?(@user)
    end

    def require_correct_user_or_admin
        set_user
        redirect_to root_url, status: :see_other, alert: "You do not have access to that page, redirected to homepage." unless current_user?(@user) || current_user_admin?
    end
end
