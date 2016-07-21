class AddJoinTableRoomsCharacters < ActiveRecord::Migration
  def change
    create_join_table :rooms, :characters, table_name: :mobiles
  end
end
