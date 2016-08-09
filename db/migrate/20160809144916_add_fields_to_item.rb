class AddFieldsToItem < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :noun, :string
    add_column :items, :level, :integer, default: 1
  end
end
