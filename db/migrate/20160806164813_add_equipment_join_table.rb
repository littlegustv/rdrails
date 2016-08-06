class AddEquipmentJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_table :equipments do |t|
      t.integer :character_id
      t.integer :weapon_id
      t.integer :head_id

      t.timestamps null: false
    end
  end
end
