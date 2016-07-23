class CharactersController < ApplicationController
  before_filter :authenticate_user!

  def new
  end

  def create
    @character = Character.new(character_params)
    @character.created_by = current_user
    if @character.save
      redirect_to @character
    else
      redirect_to new_character_path
    end
  end

  def update
    @character = Character.find(params[:id])
     
    if @character.update(character_params)
      redirect_to @character
    else
      render 'edit'
    end
  end

  def show
    @character = Character.find(params[:id])
  end

  def edit
    @character = Character.find(params[:id])
  end

  def index
    if current_user.role == 'immortal'
      @characters = Character.all
    else
      @characters = current_user.characters
    end

    respond_to do |format|
      format.json { render json: @characters }
      format.html
    end
  end

  def destroy
    @character = Character.find(params[:id])
    @character.destroy

    redirect_to characters_path
  end

  private

  def character_params
    params.require(:character).permit(:name, :description)
  end
end
