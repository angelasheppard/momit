FactoryBot.define do
    factory :user do
        username 'HanSolo'
        sequence(:email) { |n| "tester#{n}@example.com" }
        password 'random_password'
        role 'guest'

        trait :is_admin do
            role 'admin'
        end
    end
end
