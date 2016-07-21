class Character < ActiveRecord::Base

  has_many :mobiles
  has_many :rooms, through: :mobiles, class_name: "Room"

  validates :name, presence: true, length: {minimum: 2}
end
