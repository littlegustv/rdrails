json.(@character, :id, :name, :description)

json.inventory_items @character.inventory_items do |inventory_item|
	json.(inventory_item, :id, :item_id)
end

json.equipment @character.equipment.show

json.stat @character.stat.show