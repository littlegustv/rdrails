class Character < ApplicationRecord

  has_many :mobiles, dependent: :destroy
  has_many :rooms, through: :mobiles, class_name: "Room"

  has_many :inventory_items
  has_many :items, through: :inventory_items, class_name: "Item"

  has_one :equipment
  has_many :equipped, through: :equipment, class_name: "Item"

  has_many :character_skills
  has_many :skills, through: :character_skills

  belongs_to :created_by, class_name: "User"

  belongs_to :stat # weird, but since stat_id is on character, this is how it works...

  validates :name, presence: true, length: {minimum: 2}
  accepts_nested_attributes_for :stat, allow_destroy: true
  accepts_nested_attributes_for :inventory_items, allow_destroy: true
  accepts_nested_attributes_for :character_skills, allow_destroy: true
  accepts_nested_attributes_for :equipment
end
