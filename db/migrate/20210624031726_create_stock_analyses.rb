class CreateStockAnalyses < ActiveRecord::Migration[6.1]
  def change
    create_table :stock_analyses do |t|
      t.string :stock_code
      t.string :duration
      t.string :params
      t.string :results
      t.float :profit_ratio
      t.datetime :begin_time
      t.datetime :end_time

      t.timestamps
    end
    add_index :stock_analyses, :stock_code
  end
end
