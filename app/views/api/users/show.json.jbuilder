json.status 0
json.user do
  json.id @user.id
  json.username @user.username
  json.role @user.role
  json.created_at strftime_time(@user.created_at)
  json.updated_at strftime_time(@user.updated_at)
end
