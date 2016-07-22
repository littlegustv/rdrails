json.(room, :id, :name, :description)

json.mobiles room.mobiles do |mobile|
  json.(mobile.character, :name)
end