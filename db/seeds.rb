# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

public_mb_group = Thredded::MessageboardGroup.find_or_create_by(name: 'Public')
public_mb_arr = ['Recruitment']
public_mb_arr.each do |mb_name|
    Thredded::Messageboard.find_or_create_by(name: mb_name, messageboard_group_id: public_mb_group.id)
end

momit_mb_group = Thredded::MessageboardGroup.find_or_create_by(name: 'MOMiT')
momit_mb_arr = ['Class & Strategy Discussion', 'Officers', 'Recruit Voting']
momit_mb_arr.each do |mb_name|
    Thredded::Messageboard.find_or_create_by(name: mb_name, messageboard_group_id: momit_mb_group.id)
end

# Load individual seeds/ files. Each file creates a post for a specified messageboard
Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |seed|
  load seed
end


# add some data for testing our our calendar of events, only for dev 

if Rails.env == "development"
  
  # some users with different permissions
  example_admin = User.create({ email: "admin@example.com", username: "exampleadmin", password: "password", role: "admin"})
  example_admin.confirm
  example_member = User.create({ email: "member@example.com", username: "examplemember", password: "password", role: "member"})
  example_member.confirm
  example_guest = User.create({ email: "guest@example.com", username: "exampleguest", password: "password", role: "guest"})
  example_guest.confirm
  
  # example events for locked, the past, and the future
  example_fut_event = Event.create({name: "future event", description: "event in the future", start_time: 4.days.from_now, end_time: 4.days.from_now + 1.hour, event_type: "sample", is_template: 0, is_locked: 0, max_tank: 2, max_dps: 5, max_healer: 3, user_creator: example_admin})
  example_exp_event = Event.create({name: "expired event", description: "event in the past", start_time: 4.days.ago, end_time: 4.days.ago + 1.hour, event_type: "sample", is_template: 0, is_locked: 0, max_tank: 2, max_dps: 5, max_healer: 3, user_creator: example_admin})
  example_lock_event = Event.create({name: "locked event", description: "current event but locked", start_time: Time.now, end_time: Time.now + 1.hour, event_type: "sample", is_template: 0, is_locked: 1, max_tank: 2, max_dps: 5, max_healer: 3, user_creator: example_admin})

  # example chars covering some role permutations
  example_tank_char = Character.create({name: 'IAMATank', charclass: 'Warrior', is_tank: 1, is_dps: 0, is_healer: 0, main_role: 'Tank', user: example_admin})
  example_dps_char = Character.create({name: 'IAMADps', charclass: 'Mage', is_tank: 0, is_dps: 1, is_healer: 0, main_role: 'Damage', user: example_admin})
  example_healer_char = Character.create({name: 'IAMAHealer', charclass: 'Priest', is_tank: 0, is_dps: 0, is_healer: 1, main_role: 'Healer', user: example_member})
  example_hybrid_char = Character.create({name: 'IAMAHybrid', charclass: 'Druid', is_tank: 1, is_dps: 1, is_healer: 1, main_role: 'Tank', user: example_admin})

end 
