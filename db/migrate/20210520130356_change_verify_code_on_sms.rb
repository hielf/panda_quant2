class ChangeVerifyCodeOnSms < ActiveRecord::Migration[6.1]
  def change
    rename_column :sms, :verify_code, :message
    add_column :sms, :message_type, :string
  end
end
