class PushNotification < ApplicationRecord
  validates_lengths_from_database
  belongs_to :user
  belongs_to :stock_analyse

  state_machine :status, :initial => :'未发送' do
    event :sent do
      transition :'未发送' => :'已发送'
    end
    event :retry do
      transition :'已发送' => :'未发送'
    end
    event :failed do
      transition :'未发送' => :'发送失败'
    end
  end

end
