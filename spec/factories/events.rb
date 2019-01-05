FactoryBot.define do
    factory :event do
        association :creator, factory: :user
        sequence(:name) { |n| "Raid#{n}" }
        start_time { 2.days.from_now }
        end_time { 2.days.from_now + 3.hours }
    end
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
