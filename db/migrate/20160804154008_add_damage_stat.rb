class AddDamageStat < ActiveRecord::Migration[5.0]
  def change
    add_column :stats, :damage, :integer
  end
end
