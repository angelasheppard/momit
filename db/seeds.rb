# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

public_mb_group = Thredded::MessageboardGroup.find_or_create_by(name: 'Public')
momit_mb_group = Thredded::MessageboardGroup.find_or_create_by(name: 'MOMiT')
Thredded::Messageboard.find_or_create_by(name: 'Recruitment', messageboard_group_id: public_mb_group.id)