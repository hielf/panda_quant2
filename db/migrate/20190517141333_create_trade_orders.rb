class CreateTradeOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :trade_orders do |t|
      t.string :capital_account
      t.string :stock_code
      t.string :sec_name
      t.datetime :trade_date
      t.string :order_type
      t.integer :amount
      t.decimal :price, :precision => 14, :scale => 2
      t.string :status, :default => '下单'
      t.string :entrust_no

      t.timestamps
    end
  end
end
