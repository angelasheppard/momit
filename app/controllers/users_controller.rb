class UsersController < ApplicationController
    before_action :authenticate_user!, except: [:create]
    after_action :verify_authorized

    def index
        authorize current_user
        @title = "Users"
        @users = User.ordered_by_username
    end

    def show
        authorize current_user
        @user = User.find(params[:id])
        @user_detail = @user.thredded_user_detail
    end

    def edit
        authorize current_user
        @user = User.find(params[:id])
    end

    def update
        authorize current_user
        @user = User.find(params[:id])
        if params[:user][:password].blank?
            params[:user].delete(:password)
            params[:user].delete(:password_confirmation)
        end
        if @user.update_attributes(user_params)
            Log.info(current_user, "Updated User(#{@user.id})", @user.previous_changes) if @user.changed?
            redirect_to users_path, flash: {success: "User successfully updated."}
        else
            Log.notice(current_user, "Failed to update User(#{@user.id}), #{@user.errors.full_messages}")
            render :edit
        end
    end

    def destroy
        authorize current_user
        @user = User.find(params[:id])
        if @user.destroy
            Log.info(current_user, "Deleted User", @user)
            redirect_to users_path, flash: {success: "User #{@user.username} has been deleted."}
        else
            Log.notice(current_user, "Failed to delete User(#{@user.id}), #{@user.errors.full_messages}")
            render :index
        end
    end

    private
        def user_params
            params.require(:user).permit(:username, :email, :role)
        end
end
