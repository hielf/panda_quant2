json.status 0
json.message '登录成功'
json.user do
  json.(@user, :id, :mobile)
  json.token @user.access_token
end
