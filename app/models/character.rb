class Character < ActiveRecord::Base

  has_many :mobiles
  has_many :rooms, through: :mobiles, class_name: "Room"

  belongs_to :created_by, class_name: "User"

  belongs_to :stat # weird, but since stat_id is on character, this is how it works...

  validates :name, presence: true, length: {minimum: 2}
  accepts_nested_attributes_for :stat, allow_destroy: true

end
