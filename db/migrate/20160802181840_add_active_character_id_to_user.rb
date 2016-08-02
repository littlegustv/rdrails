class AddActiveCharacterIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :active_id, :integer
  end
end
