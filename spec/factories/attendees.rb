FactoryBot.define do
  factory :attendee do
    is_slotted { false }
    is_available { false }
    is_not_available { false }
    as_tank { false }
    as_dps { false }
    as_healer { false }
    did_attend { false }
    signup_note { "MyText" }
    grouplead_note { "MyText" }
    event { nil }
    character { nil }
  end
end
