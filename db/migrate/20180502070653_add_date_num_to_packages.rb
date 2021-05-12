class AddDateNumToPackages < ActiveRecord::Migration[6.1]
  def change
    add_column :packages, :date_num, :integer, :default => 30
  end
end
