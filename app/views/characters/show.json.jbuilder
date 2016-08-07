json.(@character, :id, :name, :description, :char_class)

json.inventory_items @character.inventory_items do |inventory_item|
	json.(inventory_item, :id, :item_id)
end

json.skills @character.character_skills do |cs|
	json.(cs, :skill_id)
end

json.equipment @character.equipment.show

json.stat @character.stat.show