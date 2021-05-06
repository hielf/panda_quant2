class UserStockListRel < ApplicationRecord
  belongs_to :user
  belongs_to :stock_list

  state_machine :status, :initial => :'未支付' do
    event :pay do
      transition :'未支付' => :'已支付'
    end
    event :cancel do
      transition :'未支付' => :'已取消'
    end
  end
end
