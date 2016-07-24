class AddInventoryItemJoinTable < ActiveRecord::Migration
  def change
  	create_table :inventory_items do |t|
  		t.integer :item_id
  		t.integer :character_id
  	end
  end
end
