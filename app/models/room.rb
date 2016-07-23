class Room < ActiveRecord::Base
  has_many :mobiles
  has_many :characters, through: :mobiles, class_name: "Character"

  has_many :exits
  has_many :rooms, through: :exits, foreign_key: :destination, class_name: "Room"

  accepts_nested_attributes_for :mobiles, allow_destroy: true
  accepts_nested_attributes_for :exits, allow_destroy: true

end
