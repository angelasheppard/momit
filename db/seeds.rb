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
