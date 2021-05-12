class CreatePackages < ActiveRecord::Migration[6.1]
  def change
    create_table :packages do |t|
      t.string :title
      t.string :period
      t.decimal :market_price, :precision => 10, :scale => 2
      t.decimal :discount, :precision => 3, :scale => 2
      t.decimal :real_price, :precision => 10, :scale => 2
      t.string :package_type
      t.string :desc

      t.timestamps
    end
  end
end
