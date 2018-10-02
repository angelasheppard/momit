class Character < ApplicationRecord

  CHAR_ROLES = %w[ damage healer tank ]
  CHAR_CLASSES = %w[ death_knight demon_hunter druid hunter mage monk paladin priest rogue shaman warlock warrior ]

  belongs_to :user
  has_many :attendees
  has_many :events, through: :attendees
end
