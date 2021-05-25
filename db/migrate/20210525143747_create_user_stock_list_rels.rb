class CreateUserStockListRels < ActiveRecord::Migration[6.1]
  def change
    create_table :user_stock_list_rels do |t|
      t.integer :user_id
      t.integer :stock_list_id
      t.string :status

      t.timestamps
    end
    add_index :user_stock_list_rels, :user_id
  end
end
