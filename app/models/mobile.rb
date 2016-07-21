class Mobile < ActiveRecord::Base
  belongs_to :character, class_name: "Character"
  belongs_to :room, class_name: "Room"
end
