class StockList < ApplicationRecord
  validates_lengths_from_database

  def watching_users(duration)
    current_date = Date.today

    sql = case duration
    when "1m"
      "SELECT * from users where id in (SELECT a.id FROM users a
        INNER JOIN subscribtions b on a.id = b.user_id AND b.package_type = '高级套餐' AND ('#{current_date}' BETWEEN b.start_date AND b.end_date)
        INNER JOIN user_stock_list_rels c on a.id = c.user_id
        WHERE c.stock_list_id = #{self.id})"
    when "1d"
      "SELECT * from users where id in (SELECT a.id FROM users a
        INNER JOIN subscribtions b on a.id = b.user_id AND ('#{current_date}' BETWEEN b.start_date AND b.end_date)
        INNER JOIN user_stock_list_rels c on a.id = c.user_id
        WHERE c.stock_list_id = #{self.id})"
    end
    users = User.find_by_sql(sql)

    return users
  end

end
