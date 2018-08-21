require 'rails_helper'

RSpec.feature "Users", type: :feature do
    let(:admin_user) { FactoryBot.create(:user, :is_admin) }
    before do
        sign_in admin_user
        visit root_path
    end

    context "authorized users" do
        scenario "successfully edit a user" do
            guest_user = FactoryBot.create(:user)
            click_link 'Admin'
            click_link 'Manage Users'
            expect(current_path).to eq users_path

            find_link('Edit', {href: edit_user_path(guest_user)}).click
            expect(current_path).to eq edit_user_path(guest_user)
            expect(page).to have_field('Username', with: guest_user.username)
            expect(page).to have_field('Email', with: guest_user.email)
            expect(page).to have_field('Role', with: guest_user.role)

            select('initiate', from: 'Role')
            click_button 'Update'
            expect(current_path).to eq users_path
            expect(page).to have_content "User successfully updated"
        end

        scenario "fail to edit a user" do
            guest_user = FactoryBot.create(:user)
            click_link 'Admin'
            click_link 'Manage Users'
            expect(current_path).to eq users_path

            find_link('Edit', {href: edit_user_path(guest_user)}).click
            expect(current_path).to eq edit_user_path(guest_user)
            expect(page).to have_field('Username', with: guest_user.username)
            expect(page).to have_field('Email', with: guest_user.email)
            expect(page).to have_field('Role', with: guest_user.role)

            fill_in 'Username', with: 'a' * 50
            click_button 'Update'
            expect(current_path).to eq user_path(guest_user)
            expect(page).to have_content("Username is too long")
            expect(page).to have_field('Username', with: 'a' * 50)
        end

        scenario "successfully delete a user" do
            guest_user = FactoryBot.create(:user)
            click_link 'Admin'
            click_link 'Manage Users'
            expect(current_path).to eq users_path

            find_link('Destroy', {href: user_path(guest_user)}).click
            expect(current_path).to eq users_path
            expect(page).to have_content("User #{guest_user.username} has been deleted")
            expect(page).to_not have_link('Destroy', href: user_path(guest_user))
        end
    end
end
