class CreateSms < ActiveRecord::Migration[6.1]
  def change
    create_table :sms do |t|
      t.string :mobile
      t.string :verify_code

      t.timestamps
    end
  end
end
