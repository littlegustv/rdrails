class CharactersController < ApplicationController
  def new
  end

  def create
    @character = Character.new(character_params)
    @character.save
    redirect_to @character
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
