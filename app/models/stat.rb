class Stat < ApplicationRecord
	def show
		{
			hitpoints: hitpoints,
			manapoints: manapoints,
			attackspeed: attackspeed,
			damagereduction: damagereduction,
      damage: damage,
      hitroll: hitroll
		}
	end
end
