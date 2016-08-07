class AddPlayableToCharacter < ActiveRecord::Migration[5.0]
  def change
  	add_column :characters, :playable, :boolean, default: false
  end
end
