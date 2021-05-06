FactoryBot.define do
  factory :stock_analysis do
    stock_code { "MyString" }
    duration { "MyString" }
    params { "MyString" }
    results { "MyString" }
    profit_ratio { 1.5 }
    begin_time { "2020-12-02 10:52:01" }
    end_time { "2020-12-02 10:52:01" }
  end
end
