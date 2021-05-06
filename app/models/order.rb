class Order < ApplicationRecord
  belongs_to :user
  belongs_to :package

  state_machine :status, :initial => :'未支付' do
    event :pay do
      transition :'未支付' => :'已支付'
    end
    event :cancel do
      transition :'未支付' => :'已取消'
    end
  end
end
