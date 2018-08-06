require 'rails_helper'

RSpec.describe "Header Rendering" do
    let(:guest_user) { FactoryBot.create(:user) }
    let(:initiate_user) { FactoryBot.create(:user, :is_initiate) }
    let(:member_user) { FactoryBot.create(:user, :is_member) }
    let(:officer_user) { FactoryBot.create(:user, :is_officer) }
    let(:admin_user) { FactoryBot.create(:user, :is_admin) }

    context "unauthorized users" do
        it "cannot see member or admin links" do
            render partial: 'layouts/header.html.erb'
            expect(rendered).to_not have_link('Admin')
            expect(rendered).to_not have_link('Manage Users')
        end
    end

    context "non-officer users" do
        it "cannot see admin links" do
            user_arr = [guest_user, initiate_user, member_user]
            user_arr.each do |user|
                sign_in user
                render partial: 'layouts/header.html.erb'
                expect(rendered).to_not have_link('Admin')
                expect(rendered).to_not have_link('Manage Users')
                sign_out user
            end
        end
    end

    context "officers and admin users" do
        it "can see admin links" do
            user_arr = [officer_user, admin_user]
            user_arr.each do |user|
                sign_in user
                render partial: 'layouts/header.html.erb'
                expect(rendered).to have_link('Admin')
                expect(rendered).to have_link('Manage Users')
                sign_out user
            end
        end
    end

end