FactoryBot.define do
  factory :op_log do
    user_id { 1 }
    op_type { "MyString" }
    op_message { "MyString" }
    op_time { "2021-05-27 22:19:31" }
  end
end
