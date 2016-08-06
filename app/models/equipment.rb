class Equipment < ApplicationRecord
	belongs_to :character
	belongs_to :weapon, class_name: "Item"
	belongs_to :head, class_name: "Item"

	def show
		{
			weapon_id: weapon ? weapon.id : nil,
			head_id: head ? head.id : nil
		}
	end
end