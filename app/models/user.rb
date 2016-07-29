class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :characters, foreign_key: :created_by_id
  has_one :mobile

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

end
