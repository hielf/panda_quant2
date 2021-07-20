class UserStockListRel < ApplicationRecord
  belongs_to :user
  belongs_to :stock_list

  scope :vaild, -> { where(:status => '有效') }
  scope :tryout, -> { where(:status => '试用') }

  state_machine :status, :initial => :'有效' do
    event :pay do
      transition :'过期' => :'有效'
    end
    event :cancel do
      transition :'有效' => :'过期'
    end
    event :tryout do
      transition :'有效' => :'试用'
    end
  end

  def self.watching_list_min
    where(status: "有效").filter_map{|usl| usl.stock_list if usl.user.current_subscribtion.package_type == "高级套餐"}
  end

  def self.watching_list_daily
    where(status: "有效").filter_map{|usl| usl.stock_list}
  end
end
