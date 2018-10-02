class CharactersController < ApplicationController

  def new
    @character = Character.new
  end

  def create
    @character = Character.new(character_params)
    @character.user = current_user

    if @character.save
      #success
      redirect_to characters_path
    else
      #failure
      render 'new'
    end
  end

  def show
    # get the Character that corresponds to this ID and also fetch info about the class
    @character = Character.find(params[:id])
   
    
  end

  def index
    # find all the users and then find all the characters for each user
    @users = User.all
    @characters = []
    @users.each do |u|
      @characters += user_chars(u)
    end
    
  end
  
  def byuser
      @user = User.find_by(username: username_param)
      @characters = user_chars(@user)
          
  end

  
  def byrole
    if role_param.in?(Character::CHAR_ROLES)
      @characters = Character.where(main_role: role_param).order(:name)
    else
      redirect_to characters_path
    end
  end
  
  ## TODO: byclass
  def byclass
  end


# return supplementary info from model for a given charclass
    
  private

  
    def character_params
      params.require(:character).permit(:name, :charclass, :is_tank, :is_dps, :is_healer, :main_role)
    end
    
    def username_param
      params.require(:username)
    end
    
    def role_param
      params.require(:role)
    end
    
    # return the Characters associated with a single User
    def user_chars(cuser = current_user)
        return Character.where(user: cuser).order(:name)
    end
    


end
