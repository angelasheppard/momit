require 'rails_helper'

RSpec.feature "SignUps", type: :feature do
    include ActiveJob::TestHelper

    scenario "user successfully signs up" do
        visit root_path
        click_link "Register"

        perform_enqueued_jobs do
            expect {
                fill_in "Email", with: "test@example.com"
                fill_in "Username", with: "testuser"
                fill_in "Password", with: "user123"
                fill_in "Confirm Password", with: "user123"
                click_button "Submit"
            }.to change(User, :count).by(1)

            expect(page).to \
                have_content("A message with a confirmation link has been sent to your email address")
            expect(current_path).to eq root_path
        end

        mail = ActionMailer::Base.deliveries.last

        aggregate_failures do
            expect(mail.to).to eq ["test@example.com"]
            expect(mail.from).to eq ["admin@momitguild.org"]
            expect(mail.subject).to eq "Confirmation instructions"
            expect(mail.body).to match "Welcome, testuser!"
            expect(mail.body).to match "Please confirm your MOMiT account email through the link below:"
        end
    end
end
