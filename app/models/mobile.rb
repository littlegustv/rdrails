class Mobile < ApplicationRecord
  belongs_to :character, class_name: "Character"
  belongs_to :room, class_name: "Room"
  belongs_to :user, class_name: "User"
end
