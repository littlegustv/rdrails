class AddUserForeignKeyToMobile < ActiveRecord::Migration[5.0]
  def change
    add_column :mobiles, :user_id, :integer
  end
end
