require 'rails_helper'

RSpec.feature "Confirmations", type: :feature do
    include ActiveJob::TestHelper

    before do
        visit root_path
        click_link 'Login'
        click_link 'Forgot your password?'
        click_link "Didn't receive confirmation instructions?"
    end

    scenario "user resends confirmation instructions" do
        user = FactoryBot.create(:user, :unconfirmed)
        expect(current_path).to eq new_user_confirmation_path

        # entering a valid email redirects to login page, shows flash message
        perform_enqueued_jobs do
            fill_in "Email", with: user.email
            click_button "Resend confirmation instructions"

            expect(current_path).to eq new_user_session_path
            expect(page).to have_content %{You will receive an email with instructions
                for how to confirm your email address in a few minutes.}.squish
        end

        mail = ActionMailer::Base.deliveries.last

        aggregate_failures do
            expect(mail.to).to eq [user.email]
            expect(mail.from).to eq [Devise.mailer_sender]
            expect(mail.subject).to eq "Confirmation instructions"
            expect(mail.body).to match "Welcome, #{user.username}"
            expect(mail.body).to match "Please confirm your MOMiT account email through the link below"
        end
    end

    scenario "confirmed user cannot resend confirmation" do
        user = FactoryBot.create(:user)
        expect(current_path).to eq new_user_confirmation_path

        expect {
            fill_in "Email", with: user.email
            click_button "Resend confirmation instructions"
        }.to_not change(ActionMailer::Base.deliveries, :count)

        expect(current_path).to eq "/users/confirmation"
        expect(page).to have_content "Email was already confirmed, please try signing in"
        expect(page).to have_field('Email', with: user.email)
    end

    scenario "unauthorized user cannot resend confirmation" do
        expect(current_path).to eq new_user_confirmation_path

        expect {
            fill_in "Email", with: "missing@email.com"
            click_button "Resend confirmation instructions"
        }.to_not change(ActionMailer::Base.deliveries, :count)

        expect(current_path).to eq "/users/confirmation"
        expect(page).to have_content "Email not found"
        expect(page).to have_field('Email', with: 'missing@email.com')
    end
end
