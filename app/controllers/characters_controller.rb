class CharactersController < ApplicationController
  before_filter :authenticate_user!

  def new
    @character = Character.new
    @character.stat = Stat.new
    respond_to do |format|
      format.html { render :edit }
      format.json { render :show }
    end
  end

  def create
    if params[:id] && Character.exists?(params[:id].to_i)
      @character = Character.find(params[:id])
      @character.update(character_params)
    else
      @character = Character.new(character_params)
      @character.update!(created_by: current_user)
    end
    if @character.save
      respond_to do |format|
        format.json { render :show }
        format.html
      end
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
    respond_to do |format|
      format.json { render :show }
      format.html
    end
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
    params.permit(:id, :name, :description,  :stat_attributes => [:hitpoints, :manapoints, :attackspeed, :damagereduction],  :inventory_items_attributes => [:id, :_destroy, :item_id, :character_id])
  end
end
