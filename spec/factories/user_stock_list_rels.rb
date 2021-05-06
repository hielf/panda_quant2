FactoryBot.define do
  factory :user_stock_list_rel do
    user_id { 1 }
    stock_list_id { 1 }
    status { "MyString" }
  end
end
