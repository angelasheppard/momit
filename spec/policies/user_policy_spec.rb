require 'rails_helper'

RSpec.describe UserPolicy do
    let(:guest) { FactoryBot.create(:user) }
    let(:initiate) { FactoryBot.create(:user, :is_initiate) }
    let(:member) { FactoryBot.create(:user, :is_member) }
    let(:officer) { FactoryBot.create(:user, :is_officer) }
    let(:admin) { FactoryBot.create(:user, :is_admin) }

    subject { described_class }

    permissions :index? do
        it "permits access for officers" do
            expect(subject).to permit(officer)
            expect(subject).to permit(admin)
        end
        it "denies access to non-officers" do
            expect(subject).to_not permit(guest)
            expect(subject).to_not permit(initiate)
            expect(subject).to_not permit(member)
        end
    end

    permissions :show? do
        it "permits access for members" do
            expect(subject).to permit(officer)
            expect(subject).to permit(admin)
            expect(subject).to permit(member)
        end
        it "denies access to guests and initiates" do
            expect(subject).to_not permit(guest)
            expect(subject).to_not permit(initiate)
        end
    end

    permissions :edit?, :update?, :destroy? do
        it "permits access for admins" do
            expect(subject).to permit(admin)
        end
        it "denies access to non-admins" do
            expect(subject).to_not permit(guest)
            expect(subject).to_not permit(initiate)
            expect(subject).to_not permit(member)
            expect(subject).to_not permit(officer)
        end
    end
end
