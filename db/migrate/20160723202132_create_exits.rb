class CreateExits < ActiveRecord::Migration
  def change
    create_table :exits do |t|
      t.string :direction
      t.references :destination
      t.references :room

      t.timestamps null: false
    end
  end
end
