json.(room, :id, :name, :description)

json.mobiles room.mobiles do |mobile|
  json.(mobile, :id, :character_id)
end

json.exits room.exits do |exit|
	json.(exit, :id, :direction, :destination_id)
end