require 'rails_helper'

RSpec.feature "ForgottenPassword", type: :feature do
    include ActiveJob::TestHelper

    let(:user) { FactoryBot.create(:user) }

    before do
        visit root_path
        click_link 'Login'
        click_link 'Forgot your password?'
    end

    scenario "user forgets password" do
        expect(current_path).to eq new_user_password_path

        # entering a valid email redirects to login page, shows flash message
        perform_enqueued_jobs do
            fill_in "Email", with: user.email
            click_button "Send password reset instructions"

            expect(current_path).to eq new_user_session_path
            expect(page).to have_content %{You will receive an email with
                instructions on how to reset your password in a few minutes.}.squish
        end

        mail = ActionMailer::Base.deliveries.last

        aggregate_failures do
            expect(mail.to).to eq [user.email]
            expect(mail.subject).to eq "Reset password instructions"
            expect(mail.body).to match "Hello, #{user.username}"
            expect(mail.body).to match "Someone has requested a link to reset your password"
            expect(mail.body).to match "reset_password_token"
        end
    end

    scenario "unauthorized user cannot reset password" do
        expect(current_path).to eq new_user_password_path

        expect {
            fill_in "Email", with: "missing@email.com"
            click_button "Send password reset instructions"
        }.to_not change(ActionMailer::Base.deliveries, :count)

        expect(current_path).to eq "/users/password"
        expect(page).to have_content "Email not found"
        expect(page).to have_field('Email', with: 'missing@email.com')
    end
end
