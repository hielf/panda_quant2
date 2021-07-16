class AddStockDisplayNameToStockAnalyses < ActiveRecord::Migration[6.1]
  def change
    add_column :stock_analyses, :stock_display_name, :string
  end
end
