class ClientsController < ApplicationController

  def index
    if params[:play]
      # here is where we have a problem
      # LOGIN: if existing 'active' PC in database, load that?
      if current_user.active && current_user.active.character_id == params[:play]
        # how to switch player characters...
        "Currently active character"
      else
        mobiles = Mobile.where(character_id: params[:play], user_id: current_user.id)
        if (mobiles.count > 0)
          puts "Existing mobile, swapping"
          current_user.update(active_id: mobiles.first.id)
        else
          puts "Create new mobile"
          current_user.active = Mobile.create(character_id: params[:play], room_id: Room.first.id, user_id: current_user.id)
        end
      end
    end
    ActionCable.server.broadcast "server",
    message: "login",
    user: current_user.id

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