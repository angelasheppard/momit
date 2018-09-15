class Attendee < ApplicationRecord
  belongs_to :event
  belongs_to :character
end
