class ItemsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @item = Item.new
    @item.stat = Stat.new
  end

  def edit
    @item = Item.find(params[:id])
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to @item
    else
      redirect_to new_item_path
    end
  end

  def index
  	@items = Item.all
    respond_to do |format|
      format.json { render json: @items }
      format.html
    end
  end

  def show
  	@item = Item.find(params[:id])
  end

  private

  def item_params
  	params.require(:item).permit(:name, :description, :stat_attributes => [:hitpoints, :manapoints, :attackspeed, :damagereduction])
  end

end