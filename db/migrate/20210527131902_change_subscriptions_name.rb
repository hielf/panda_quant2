class ChangeSubscriptionsName < ActiveRecord::Migration[6.1]
  def change
    rename_table :subscriptions, :subscribtions
  end
end
