FactoryBot.define do
  factory :character do
    name { "MyString" }
    charclass { "MyString" }
    is_tank { false }
    is_dps { false }
    is_healer { false }
    main_role { "MyString" }
    user { nil }
  end
end
