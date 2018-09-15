class Character < ApplicationRecord
  belongs_to :user
  has_many :attendees
  has_many :events, through: :attendees
end
