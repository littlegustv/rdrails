class AddSlotToItem < ActiveRecord::Migration[5.0]
  def change
  	add_column :items, :slot, :string, default: "head"
  end
end
