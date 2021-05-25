class AddWatchNumToPackages < ActiveRecord::Migration[6.1]
  def change
    add_column :packages, :watch_num, :integer
  end
end
