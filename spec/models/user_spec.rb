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

    describe "role" do
        it "is assigned a default role" do
            user = FactoryBot.build(:user)
            user.valid?
            expect(user.role).to_not be_nil
        end

        it "is invalid without a role" do
            user = FactoryBot.build(:user, :without_role)
            user.valid?
            expect(user).to_not be_valid
        end
    end

    describe "email" do
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
    end

    describe "username" do
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

        it "is invalid with a length of less than 3 characters" do
            user = FactoryBot.build(:user, username: 'ac')
            user.valid?
            expect(user).to_not be_valid
        end

        it "is valid with a length of 3 characters" do
            user = FactoryBot.build(:user, username: 'abc')
            user.valid?
            expect(user).to be_valid
        end

        it "is valid with a length between 3 and 30 chars" do
            user = FactoryBot.build(:user, username: 'abcdefghi')
            user.valid?
            expect(user).to be_valid
        end

        it "is valid with a length of 30 characters" do
            user = FactoryBot.build(:user, username: 'abc' * 10)
            user.valid?
            expect(user).to be_valid
        end

        it "is invalid with a length of more than 30 characters" do
            user = FactoryBot.build(:user, username: 'abc' * 10 + 'a')
            user.valid?
            expect(user).to_not be_valid
        end
    end
end
