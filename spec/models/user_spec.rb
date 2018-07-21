require 'rails_helper'

RSpec.describe User, type: :model do
    it "has a valid factory" do
        expect(FactoryBot.build(:user)).to be_valid
    end

    it "is valid with an email, username, and role" do
        user = FactoryBot.build(:user)
        user.valid?
        expect(user).to be_valid
    end

    it "is invalid without a username" do
        user = FactoryBot.build(:user, username: nil)
        user.valid?
        expect(user).to_not be_valid
    end

    it "is invalid with duplicate usernames" do
        user1 = FactoryBot.create(:user)
        user2 = FactoryBot.build(:user)
        user2.valid?
        expect(user2.errors[:username]).to include('has already been taken')
    end

    describe "check username length" do
        it "is valid with a username of 3 characters" do
            user = FactoryBot.build(:user, username: 'abc')
            user.valid?
            expect(user).to be_valid
        end

        it "is valid with a username between 3 and 30 chars" do
            user = FactoryBot.build(:user, username: 'abcdefghi')
            user.valid?
            expect(user).to be_valid
        end

        it "is valid with a username of 30 characters" do
            user = FactoryBot.build(:user, username: 'abc' * 10)
            user.valid?
            expect(user).to be_valid
        end

        it "is invalid with a username of less than 3 characters" do
            user = FactoryBot.build(:user, username: 'ac')
            user.valid?
            expect(user).to_not be_valid
        end

        it "is invalid with a username of more than 30 characters" do
            user = FactoryBot.build(:user, username: 'abc' * 10 + 'a')
            user.valid?
            expect(user).to_not be_valid
        end
    end

    it "is invalid without an email" do
        user = FactoryBot.build(:user, email: nil)
        user.valid?
        expect(user).to_not be_valid
    end

    it "is invalid with duplicate email" do
        user1 = FactoryBot.create(:user)
        user2 = FactoryBot.build(:user, email: user1.email)
        user2.valid?
        expect(user2.errors[:email]).to include('has already been taken')
    end

    it "is assigned a default role" do
        user = FactoryBot.build(:user)
        user.valid?
        expect(user.role).to_not be_nil
    end
end
