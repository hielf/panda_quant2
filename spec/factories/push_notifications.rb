FactoryBot.define do
  factory :push_notification do
    user_id { 1 }
    note_type { "MyString" }
    status { "MyString" }
    stock_code { "MyString" }
    stock_display_name { "MyString" }
    duration { "MyString" }
    begin_time { "" }
    end_time { "2021-07-17 00:51:33" }
    send_time { "2021-07-17 00:51:33" }
  end
end
