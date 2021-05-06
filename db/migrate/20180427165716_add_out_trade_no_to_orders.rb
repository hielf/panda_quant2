class AddOutTradeNoToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :out_trade_no, :string

    add_index :orders, :out_trade_no
  end
end
