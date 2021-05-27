class CreateOpLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :op_logs do |t|
      t.integer :user_id
      t.string :op_type
      t.string :op_message
      t.datetime :op_time

      t.timestamps
    end
    add_index :op_logs, :user_id
  end
end
