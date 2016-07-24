class Item < ActiveRecord::Base
	
	belongs_to :stat
  accepts_nested_attributes_for :stat, allow_destroy: true

  has_many :room_items
  has_many :rooms, through: :room_items, class_name: "Room"

  has_many :inventory_items
  has_many :characters, through: :inventory_items, class_name: "Character"

end
