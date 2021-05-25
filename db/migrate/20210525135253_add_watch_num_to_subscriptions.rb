class AddWatchNumToSubscriptions < ActiveRecord::Migration[6.1]
  def change
    add_column :subscriptions, :watch_num, :integer
  end
end
