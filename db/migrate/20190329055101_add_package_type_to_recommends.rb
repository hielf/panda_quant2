class AddPackageTypeToRecommends < ActiveRecord::Migration[5.1]
  def change
    add_column :recommends, :package_type, :string
  end
end
