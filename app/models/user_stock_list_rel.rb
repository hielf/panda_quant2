class UserStockListRel < ApplicationRecord
  belongs_to :user
  belongs_to :stock_list

  state_machine :status, :initial => :'有效' do
    event :pay do
      transition :'过期' => :'有效'
    end
    event :cancel do
      transition :'有效' => :'过期'
    end
  end
end
