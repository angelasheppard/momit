class UsersController < ApplicationController
    before_action :authenticate_user!, except: [:create]
    
    def index
        @title = "Users"
        @users = User.all
    end

    private
        def user_params
            params.require(:user).permit(:username, :email)
        end
end
