class UsersController < ApplicationController
    before_action :authenticate_user!, except: [:create]

    def index
        @title = "Users"
        @users = User.ordered_by_username
    end

    private
        def user_params
            params.require(:user).permit(:username, :email, :role)
        end
end
