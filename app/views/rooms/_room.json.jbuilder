json.(room, :id, :name, :description)

json.mobiles room.mobiles do |mobile|
  json.(mobile, :id, :character_id)
end

json.exits room.exits do |exit|
	json.(exit, :id, :direction, :destination_id)
end

json.room_items room.room_items do |room_item|
	json.(room_item, :id, :item_id)
end