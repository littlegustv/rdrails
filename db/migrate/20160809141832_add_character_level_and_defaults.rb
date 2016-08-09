class AddCharacterLevelAndDefaults < ActiveRecord::Migration[5.0]
  def change
    add_column :characters, :level, :integer, default: 1
    add_column :characters, :experience, :integer, default: 0
    change_column :character_skills, :percentage, :integer, default: 75
    change_column :skills, :cp, :integer, default: 1
    change_column :skills, :level, :integer, default: 1
  end
end
