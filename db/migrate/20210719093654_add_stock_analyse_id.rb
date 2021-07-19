class AddStockAnalyseId < ActiveRecord::Migration[6.1]
  def change
    add_column :push_notifications, :stock_analyse_id, :integer
  end
end
