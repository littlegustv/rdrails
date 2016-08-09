class AddStatsDefaults < ActiveRecord::Migration[5.0]
  def change
    change_column :stats, :hitpoints, :integer, default: 100
    change_column :stats, :manapoints, :integer, default: 80
    change_column :stats, :attackspeed, :integer, default: 0
    change_column :stats, :damage, :integer, default: 5
    change_column :stats, :damagereduction, :integer, default: 0
    add_column :stats, :hitroll, :integer, default: 1
  end
end
