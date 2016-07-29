class ClientsController < ApplicationController

  def index
    if params[:play]
      current_user.mobile = Mobile.create(character_id: params[:play], room_id: Room.first.id)
      puts "why. #{current_user.mobile.character.name}"
      ActionCable.server.broadcast "server",
      message: "login",
      user: current_user.id
    end

    if params[:content]
      ActionCable.server.broadcast "server",
        message: params[:content].to_s,
        user: current_user.id
      head :ok
    end
  end

  def create
  end

end