class CreatePushNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :push_notifications do |t|
      t.integer :user_id
      t.string :note_type
      t.string :status
      t.string :stock_code
      t.string :stock_display_name
      t.string :duration
      t.datetime :begin_time
      t.datetime :end_time
      t.datetime :send_time

      t.timestamps
    end
    add_index :push_notifications, :user_id
    add_index :push_notifications, :status
  end
end
