class Event < ApplicationRecord
    belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
    has_many :attendees
    has_many :characters, through: :attendees

    validates :name, presence: true, length: { maximum: 100 }, uniqueness: { scope: :start_time }
    validates :start_time, :end_time, presence: true
end

# == Schema Information
#
# Table name: events
#
#  id          :bigint(8)        not null, primary key
#  description :text
#  end_time    :datetime         not null
#  event_type  :string
#  is_locked   :boolean
#  is_template :boolean
#  log_url     :string
#  max_dps     :integer
#  max_healer  :integer
#  max_tank    :integer
#  name        :string(100)      not null
#  start_time  :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  creator_id  :integer          not null
#
# Indexes
#
#  index_events_on_creator_id           (creator_id)
#  index_events_on_name_and_start_time  (name,start_time) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#
