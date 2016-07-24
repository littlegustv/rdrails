class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.integer :hitpoints
      t.integer :manapoints
      t.integer :attackspeed
      t.integer :damagereduction

      t.timestamps null: false
    end
  end
end
