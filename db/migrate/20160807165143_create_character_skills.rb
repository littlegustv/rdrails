class CreateCharacterSkills < ActiveRecord::Migration[5.0]
  def change
    create_table :character_skills do |t|
      t.integer :character_id
      t.integer :skill_id
      t.integer :percentage

      t.timestamps
    end
  end
end
