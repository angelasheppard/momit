class UsersController < ApplicationController
    before_action :authenticate_user!, except: [:create]
    after_action :verify_authorized

    def index
        @title = "Users"
        @users = User.ordered_by_username
        authorize current_user
    end

    def edit
    end

    private
        def user_params
            params.require(:user).permit(:username, :email, :role)
        end
end
