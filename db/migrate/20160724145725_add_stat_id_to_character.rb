class AddStatIdToCharacter < ActiveRecord::Migration
  def change
  	add_column :characters, :stat_id, :integer
  end
end
