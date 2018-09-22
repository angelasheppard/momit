class CharactersController < ApplicationController

  def new
    @character = Character.new
  end

  def create
    @character = Character.new(Character_params)
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
    # get all characters and supplement the info
    @characters = Character.all.order(:main_role)
    @chars_plus_info = []
    @characters.each do |c|
      new_character_element = { c => char_props(c.charclass) }
      @chars_plus_info << new_character_element
    end

  end
  
  def showonlymine
      @characters = user_chars_plus(current_user)
          
  end



# return supplementary info from model for a given charclass
  def char_props(charclass)
    char_info = Character::CHAR_CLASSES[charclass.downcase.to_sym]
    return char_info
  end
    
  private

    def character_params
      params.require(:character).permit(:name, :charclass, :is_tank, :is_dps, :is_heal, :main_role)
    end
    
    # return the characters associated with a single User, supplemented with stored model info
    # return format: array with Character as key, hash of properties as value
    def user_chars_plus(cuser = current_user)
        char_objs = user_chars(cuser)
        chars_plus_info = {}
        char_objs.each do |c|
            new_character_element = { c =>  char_props(c.charclass) }
            chars_plus_info << new_character_element
        end
        return chars_plus_info
    end
    
    # return the Characters associated with a single User
    def user_chars(cuser = current_user)
        return Character.where(:user == cuser).order(:main_role )
    end
    


end
