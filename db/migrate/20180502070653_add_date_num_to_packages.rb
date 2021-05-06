class AddDateNumToPackages < ActiveRecord::Migration[5.1]
  def change
    add_column :packages, :date_num, :integer, :default => 30
  end
end
