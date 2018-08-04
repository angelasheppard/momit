require 'rails_helper'

RSpec.feature "EditProfile", type: :feature do
    before do
        @user = FactoryBot.create(:user)
        sign_in @user
        visit root_path
    end

    scenario "user successfully edits profile" do
        click_link "Edit Profile"
        expect(current_path).to eq edit_user_registration_path
        expect(page).to have_field("Username", with: @user.username)
        expect(page).to have_field("Email", with: @user.email)

        fill_in "Password", with: "NewPassword"
        fill_in "Confirm Password", with: "NewPassword"
        fill_in "Current Password", with: @user.password
        click_button "Update"

        expect(current_path).to eq root_path
        expect(page).to have_content("Your account has been updated successfully.")
    end

    scenario "user cannot edit profile with invalid password" do
        click_link "Edit Profile"
        expect(current_path).to eq edit_user_registration_path
        expect(page).to have_field("Username", with: @user.username)
        expect(page).to have_field("Email", with: @user.email)

        fill_in "Password", with: "Pass123"
        fill_in "Confirm Password", with: "Pass123"
        fill_in "Current Password", with: "NotAPassword"
        click_button "Update"

        expect(current_path).to eq "/users"
        expect(page).to have_content("Current password is invalid")
    end

    scenario "user cancels account" do
        click_link "Edit Profile"
        expect(current_path).to eq edit_user_registration_path
        click_link "Cancel my account"
        expect(current_path).to eq root_path
        expect(page).to have_content("Bye! Your account has been successfully cancelled. We hope to see you again soon.")
    end
end
