FactoryBot.define do
    factory :user do
        sequence(:username) { |n| "HanSolo#{n}" }
        sequence(:email) { |n| "tester#{n}@example.com" }
        password { 'random_password' }
        role { 'guest' }
        confirmed_at { Date.today }

        trait :is_initiate do
            role { 'initiate' }
        end

        trait :is_member do
            role { 'member' }
        end

        trait :is_officer do
            role { 'officer' }
        end

        trait :is_admin do
            role { 'admin' }
        end

        trait :without_role do
            role { nil }
        end

        trait :unconfirmed do
            confirmed_at { nil }
        end
    end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  username               :string(30)       not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role                  (role)
#  index_users_on_username              (username) UNIQUE
#
