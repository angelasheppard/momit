require 'rails_helper'

RSpec.feature "Users", type: :feature do
    context "authorized users" do
        let(:admin_user) { FactoryBot.create(:user, :is_admin) }
        before do
            sign_in admin_user
            visit root_path
        end

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

    context "when logged in as a guest" do
        let(:guest_user) { create(:user) }
        before do
            sign_in guest_user
            visit thredded_path
        end

        scenario "only public messageboards are visible" do
            expect(page).to have_content('Public')
            expect(page).to have_link('Recruitment', href: "/forum/recruitment")
            expect(page).to_not have_link('Officers', href: '/forum/officers')
        end

        scenario "can write to visible messageboards" do
            visit "/forum/#{guest_user.thredded_can_write_messageboards.map(&:name).first.parameterize}"
            expect(page).to have_field('Start a New Topic')
        end

        scenario "cannot visit restricted messageboards" do
            visit "/forum/recruit-voting"
            expect(page).to have_content('not authorized')
        end
    end
    context "when logged in as an initiate" do
        let(:initiate_user) { create(:user, :is_initiate) }
        before do
            sign_in initiate_user
            visit thredded_path
        end

        scenario "public and some momit messageboards are visible" do
            expect(page).to have_content('Public')
            expect(page).to have_selector('h3', text: 'MOMiT')
            expect(page).to have_link('Recruitment', href: "/forum/recruitment")
            expect(page).to have_link('Class & Strategy Discussion', href: '/forum/class-strategy-discussion')
            expect(page).to_not have_link('Officers', href: '/forum/officers')
            expect(page).to_not have_link('Recruit Voting', href: '/forum/recruit-voting')
        end

        scenario "can write to visible messageboards" do
            visit "/forum/#{initiate_user.thredded_can_write_messageboards.map(&:name).first.parameterize}"
            expect(page).to have_field('Start a New Topic')
        end

        scenario "cannot visit restricted messageboards" do
            visit "/forum/recruit-voting"
            expect(page).to have_content('not authorized')
        end
    end

    context "when logged in as a member" do
        let(:member_user) { create(:user, :is_member) }
        before do
            sign_in member_user
            visit thredded_path
        end

        scenario "public and some momit messageboards are visible" do
            expect(page).to have_content('Public')
            expect(page).to have_selector('h3', text: 'MOMiT')
            expect(page).to have_link('Recruitment', href: "/forum/recruitment")
            expect(page).to have_link('Class & Strategy Discussion', href: '/forum/class-strategy-discussion')
            expect(page).to have_link('Recruit Voting', href: '/forum/recruit-voting')
            expect(page).to_not have_link('Officers', href: '/forum/officers')
        end

        scenario "can write to visible messageboards" do
            visit "/forum/#{member_user.thredded_can_write_messageboards.map(&:name).first.parameterize}"
            expect(page).to have_field('Start a New Topic')
        end

        scenario "cannot visit restricted messageboards" do
            visit "/forum/officers"
            expect(page).to have_content('not authorized')
        end
    end
    context "when logged in an as officer" do
        let(:officer_user) { create(:user, :is_officer) }
        before do
            sign_in officer_user
            visit thredded_path
        end
        scenario "all messageboards are visible" do
            expect(page).to have_content('Public')
            expect(page).to have_selector('h3', text: 'MOMiT')
            expect(page).to have_link('Recruitment', href: "/forum/recruitment")
            expect(page).to have_link('Class & Strategy Discussion', href: '/forum/class-strategy-discussion')
            expect(page).to have_link('Recruit Voting', href: '/forum/recruit-voting')
            expect(page).to have_link('Officers', href: '/forum/officers')
        end

        scenario "can write to visible messageboards" do
            visit "/forum/#{officer_user.thredded_can_write_messageboards.map(&:name).first.parameterize}"
            expect(page).to have_field('Start a New Topic')
        end
    end

    context "when logged in as an admin" do
        let(:admin_user) { create(:user, :is_admin) }
        before do
            sign_in admin_user
            visit thredded_path
        end
        scenario "all messageboards are visible" do
            expect(page).to have_content('Public')
            expect(page).to have_selector('h3', text: 'MOMiT')
            expect(page).to have_link('Recruitment', href: "/forum/recruitment")
            expect(page).to have_link('Class & Strategy Discussion', href: '/forum/class-strategy-discussion')
            expect(page).to have_link('Recruit Voting', href: '/forum/recruit-voting')
            expect(page).to have_link('Officers', href: '/forum/officers')
        end

        scenario "can write to visible messageboards" do
            visit "/forum/#{admin_user.thredded_can_write_messageboards.map(&:name).first.parameterize}"
            expect(page).to have_field('Start a New Topic')
        end
    end
end
