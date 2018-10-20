FactoryBot.define do
  factory :event do
    name { "MyString" }
    description { "MyText" }
    start_time { "2018-09-15 16:13:10" }
    end_time { "2018-09-15 16:13:10" }
    event_type { "MyString" }
    is_template { false }
    is_locked { false }
    max_tank { 1 }
    max_dps { 1 }
    max { "MyString" }
    healer { 1 }
    log_url { "MyString" }
    user { nil }
  end
end
