json.status 0
json.message '获取成功'
json.data @openid
# json.data do
#   json.users do
#     json.array! @users do |user|
#       json.(user, :id, :username, :name, :role)
#       json.created_at strftime_time(user.created_at)
#       json.updated_at strftime_time(user.updated_at)
#     end
#   end
# end
