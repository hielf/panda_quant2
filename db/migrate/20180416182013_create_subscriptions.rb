class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.date :start_date
      t.date :end_date
      t.string :package_type
      t.string :note

      t.timestamps
    end
    add_index :subscriptions, :user_id
  end
end
