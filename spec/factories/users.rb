FactoryBot.define do
    factory :user do
        username 'HanSolo'
        sequence(:email) { |n| "tester#{n}@example.com" }
        password 'random_password'
        role 'guest'
        confirmed_at Date.today

        trait :is_initiate do
            role 'initiate'
        end

        trait :is_member do
            role 'member'
        end

        trait :is_admin do
            role 'admin'
        end

        trait :without_role do
            role nil
        end
    end
end
