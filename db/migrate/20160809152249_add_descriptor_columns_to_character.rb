class AddDescriptorColumnsToCharacter < ActiveRecord::Migration[5.0]
  def change
    add_column :characters, :short, :string
    add_column :characters, :long, :string
    add_column :characters, :keywords, :text
  end
end
