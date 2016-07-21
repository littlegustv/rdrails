class Room < ActiveRecord::Base
  has_many :mobiles
  has_many :characters, through: :mobiles, class_name: "Character"

  accepts_nested_attributes_for :mobiles

end
