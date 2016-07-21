class AddPrimaryKeyToMobiles < ActiveRecord::Migration
  def change
    add_column :mobiles, :id, :primary_key
  end
end
