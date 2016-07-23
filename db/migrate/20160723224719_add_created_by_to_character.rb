class AddCreatedByToCharacter < ActiveRecord::Migration
  def change
  	add_column :characters, :created_by, :reference, :default => 1
  end
end
