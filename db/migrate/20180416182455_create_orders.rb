class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :package_id
      t.decimal :amount, :precision => 10, :scale => 2
      t.string :status

      t.timestamps
    end
    add_index :orders, :user_id
  end
end
