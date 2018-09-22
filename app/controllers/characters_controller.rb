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
    @character_class = Character::CHAR_CLASSES[@character.charclass.downcase.to_sym][:display_name]
    @character_icon_loc = Character::CHAR_CLASSES[@character.charclass.downcase.to_sym][:display_icon]
    
  end

  def index
    # find all the users and then find all the characters for each user
    @users = User.all
    @characters = []
    @users.each do |u|
      @characters += user_chars_plus(u)
    end
    
  end
  
  def byuser
      @user = User.find_by(username: username_param)
      @characters = user_chars_plus(@user)
          
  end

  ## TODO: byrole, byclass
  def byrole
  end
  
  def byclass
  end


# return supplementary info from model for a given charclass
    
  private

    def char_props(charclass)
      char_info = Character::CHAR_CLASSES[charclass.downcase.to_sym]
      return char_info
    end
  
    def character_params
      params.require(:character).permit(:name, :charclass, :is_tank, :is_dps, :is_heal, :main_role)
    end
    
    def username_param
      params.require(:username)
    end
    # return the characters associated with a single User, supplemented with stored model info
    # return format: array with Character as key, hash of properties as value
    def user_chars_plus(cuser = current_user)
        char_objs = user_chars(cuser)
        chars_plus_info = []
        char_objs.each do |c|
            new_character_element = { "character" => c, "properties" =>  char_props(c.charclass) }
            chars_plus_info << new_character_element
        end
        return chars_plus_info
    end
    
    # return the Characters associated with a single User
    def user_chars(cuser = current_user)
        return Character.where(user: cuser).order(:name)
    end
    


end
