class Room < ApplicationRecord
  has_many :mobiles
  has_many :characters, through: :mobiles, class_name: "Character"

  has_many :exits
  has_many :rooms, through: :exits, foreign_key: :destination, class_name: "Room"

  has_many :room_items
  has_many :items, through: :room_items, class_name: "Item"

  belongs_to :area

  accepts_nested_attributes_for :room_items, allow_destroy: true
  accepts_nested_attributes_for :mobiles, allow_destroy: true
  accepts_nested_attributes_for :exits, allow_destroy: true

  def display
    display = %(
      <h1>#{name}</h1>
      <p>#{description}</p>
      <ul class="list-inline">
        #{characters.map { |c| '<li>' + c.name + '</li>'}.join}
      </ul>
      <ul style="list-style: none;">
        #{room_items.map { |c| '<li>' + c.item.name + '</li>'}.join}
      </ul>
      <ul class="list-inline">
        <li class="h4">Exits</li>
        #{exits.map { |c| '<li>' + c.direction + '</li>'}.join}
      </ul>
    )
  end

end
