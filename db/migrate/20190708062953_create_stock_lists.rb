class CreateStockLists < ActiveRecord::Migration[6.1]
  def change
    create_table :stock_lists do |t|
      t.string :stock_code
      t.string :stock_display_name
      t.string :stock_name
      t.string :market_code
      t.string :market

      t.timestamps
    end
    add_index :stock_lists, :stock_code
    add_index :stock_lists, :stock_display_name
    add_index :stock_lists, :stock_name
  end
end
