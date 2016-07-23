class Character < ActiveRecord::Base

  has_many :mobiles
  has_many :rooms, through: :mobiles, class_name: "Room"

  belongs_to :created_by, class_name: "User"

  validates :name, presence: true, length: {minimum: 2}
end
