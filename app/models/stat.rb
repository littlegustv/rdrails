class Stat < ApplicationRecord
	def show
		{
			hitpoints: hitpoints,
			manapoints: manapoints,
			attackspeed: attackspeed,
			damagereduction: damagereduction
		}
	end
end
