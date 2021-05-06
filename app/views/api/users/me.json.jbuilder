json.status 0
json.message '获取成功'

json.data do
  json.id @user.id
  if @subscribe.empty?
    json.package "尚未订阅"
    json.subscribe_date_num 0
  else
    json.package @user.subscriptions.last.package_type
    json.subscribe_date_num (@user.subscriptions.maximum(:end_date) - Date.today).to_i
  end
  json.created_at strftime_time(@user.created_at)
  json.updated_at strftime_time(@user.updated_at)
end
