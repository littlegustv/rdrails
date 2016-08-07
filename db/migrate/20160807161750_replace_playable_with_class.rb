class ReplacePlayableWithClass < ActiveRecord::Migration[5.0]
  def change
  	#remove_column :characters, :playable
  	add_column :characters, :char_class, :string
  end
end
