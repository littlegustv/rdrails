class AddCreatedByToCharacter < ActiveRecord::Migration
  def change
  	add_column :characters, :created_by_id, :integer
  end
end
