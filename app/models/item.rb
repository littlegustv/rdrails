class Item < ActiveRecord::Base
	
	belongs_to :stat
  accepts_nested_attributes_for :stat, allow_destroy: true

  has_many :room_items
  has_many :rooms, through: :room_items, class_name: "Room"

end
