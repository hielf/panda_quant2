class RemoveIndexFormUsers < ActiveRecord::Migration[5.1]
  def change
    remove_index "users", name: "index_users_on_mobile"
    add_index :users, :mobile
  end
end
