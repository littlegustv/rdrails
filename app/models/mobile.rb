class Mobile < ApplicationRecord
  belongs_to :character, class_name: "Character"
  belongs_to :room, class_name: "Room"
  belongs_to :user, class_name: "User"

  def move(direction)
    exits = room.exits.where(direction: direction)
    if exits.count > 0
      assign_attributes(room_id: exits.first.destination_id)
      return "You move #{direction}."
    else
      return "You can't go that way."
    end
  end

  def speak(msg)
    user.send(msg) if user
  end
end
