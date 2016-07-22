class RoomsController < ApplicationController
  def new
    @room = Room.new
    @room.mobiles.build
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to @room
    else
      redirect_to new_room_path
    end
  end

  def update
    @room = Room.find(params[:id])
     
    if @room.update(room_params)
      redirect_to @room
    else
      render 'edit'
    end
  end

  def show
    @room = Room.find(params[:id])
    respond_to do |format|
      format.json { render :show }
      format.html
    end
  end

  def edit
    @room = Room.find(params[:id])
  end
  
  def destroy
    @room = Room.find(params[:id])
    @room.destroy

    redirect_to rooms_path
  end

  def index
    @rooms = Room.all
    respond_to do |format|
      format.json { render json: @rooms }
      format.html
    end
  end

  private

  def room_params
    params.require(:room).permit(:name, :description, mobiles_attributes: [:character_id, :room_id] )
  end
end
