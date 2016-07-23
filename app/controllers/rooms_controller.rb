class RoomsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @room = Room.new
    render :edit
    #redirect_to edit_room_path
  end

  def create
    if params[:id] && Room.exists?(params[:id].to_i)
      @room = Room.find(params[:id])
      @room.update(room_params)
    else
      @room = Room.new(room_params)
    end
    if @room.save
      respond_to do |format|
        format.json { render :show }
        format.html
      end
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
    @mobiles = @room.mobiles
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
    params.permit(:name, :description, mobiles_attributes: [:id, :character_id, :room_id, :_destroy], exits_attributes: [:id, :room_id, :destination_id, :direction, :_destroy] )
  end
end
