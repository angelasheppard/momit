class Event < ApplicationRecord
  belongs_to :user_creator, class_name: "User"
  has_many :attendees
  has_many :characters, through: :attendees 
end
