class ClientsController < ApplicationController

  def index
    if params[:play]
      puts "PLAY"
      if current_user.mobile && current_user.mobile.character_id != params[:play].to_i
        puts "You are already playing as a character.  Do you wish to log out? #{current_user.mobile.character_id}"
      else
        if current_user.mobile.nil?
          current_user.mobile = Mobile.create(character_id: params[:play], room_id: Room.first.id)
        end
        ActionCable.server.broadcast "server",
        message: "login",
        user: current_user.id
      end
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