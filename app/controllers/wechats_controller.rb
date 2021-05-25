class WechatsController < ApplicationController
  # For details on the DSL available within this file, see https://github.com/Eric-Guo/wechat#wechat_responder---rails-responder-controller-dsl
  wechat_responder

  on :event, with: 'subscribe' do |request|
    openid = request[:FromUserName]
    new_user = Wechat.api.user "oEJU4v32gZGQlCMCuUmZMDNgxUHs"
    nickname = new_user["nickname"]
    avatar = new_user["headimgurl"]
    user = User.find_or_initialize_by(openid: openid)
    if user.save!
      user.update(nickname: nickname, avatar: avatar)
    end
    wechat.custom_message_send Wechat::Message.to(openid).text("欢迎关注本工具:\na)我们为您实时扫描订阅的证券行情\nb)在W形态买入点出现时向您发出通知")
    wechat.custom_message_send Wechat::Message.to(openid).text("更多使用说明请浏览'帮助'")
    request.reply.success
  end

  # 验证手机号
  on :text, with: /^1[3-9]\d{9}$/ do |request|
    openid = request[:FromUserName]
    mobile = request[:Content]
    # if content.match(/^1[3-9]\d{9}$/)
    #   true
    # end
    request.message_hash.each do |key, value|
      Rails.logger.warn "#{key}: #{value}"
    end

    begin
      SmsJob.perform_later mobile, "verify_code", ""
    rescue Exception => ex
      Rails.logger.warn "#{ex.message}"
    end

    wechat.custom_message_send Wechat::Message.to(openid).text("已发送短信验证码至：#{mobile}\n请在下方的对话栏内回复4位数字验证码")
    request.reply.success
    # request.reply.text "已发送短信验证码至手机号码：#{content}/n请在下方的对话栏内回复6位数字验证码"
  end

  # 验证码
  on :text, with: /^\d{4}$/ do |request|
    openid = request[:FromUserName]
    verify_code = request[:Content]

    request.message_hash.each do |key, value|
      Rails.logger.warn "#{key}: #{value}"
    end

    last_sm = Sm.where("message = ? AND message_type = ? AND created_at > ?", verify_code, "verify_code", 5.minutes.ago).last
    if last_sm
      user = User.find_by(openid: openid)
      user.update(mobile: last_sm.mobile)
      request.reply.text "验证通过，已为您绑定接收通知的手机"
    else
      request.reply.text "您输入的验证码有误，请重新输入或再次输入手机号获取验证码"
    end
  end

  #subscribe
  on :click, with: 'SUBSCRIBE' do |request, key|
    openid = request[:FromUserName]
    user = User.find_by(openid: openid)
    subscription = user.subscriptions.last
    package_type = subscription.nil? ? "未订阅" : subscription.package_type
    # package = Package.find_by(package_type: subscription.package_type)
    user_stock_list = user.stock_lists
    rest_watch_num = subscription.nil? ? 0 : (subscription.watch_num - user_stock_list.count)
    wechat.custom_message_send Wechat::Message.to(openid).text("您当前使用的套餐为：
      #{package_type}\n已订阅数量为：
      #{user_stock_list.count}\n剩余可订阅数量：
      #{rest_watch_num}")
    wechat.custom_message_send Wechat::Message.to(openid).text("请回复下列序号：")
    wechat.custom_message_send Wechat::Message.to(openid).text("1）继续订阅\n2）查询当前订阅列表\n3）删除订阅")

    request.reply.text "User: #{request[:FromUserName]} click #{key}"
  end

  # When user click the menu button
  # on :click, with: 'SUBSCRIBE' do |request, key|
  on :text, with: 'order' do |request, content|
    openid = request[:FromUserName]
    path = Rails.root.to_s + "/app/views/templates/order_success.yml"
    template = YAML.load(File.read(path))
    template["template"]["url"] = "http://"
    template["template"]["data"]["first"]["value"] = "title"
    template["template"]["data"]["keyword1"]["value"] = "时间"
    template["template"]["data"]["keyword2"]["value"] = "类型"
    template["template"]["data"]["keyword3"]["value"] = "描述"
    template["template"]["data"]["keyword4"]["value"] = "状态"
    template["template"]["data"]["remark"]["value"] = "备注"
    # Wechat.api.template_message_send Wechat::Message.to(openid).template(template['template'])
    # Wechat.api.custom_message_send Wechat::Message.to(openid).text("ggg")
    # Wechat.api.custom_message_send Wechat::Message.to(openid).text("ggg\n111\neee\n<a href='http://wechat.devzeng.com/register'>【点此开始注册】</a>")
    wechat.template_message_send Wechat::Message.to(openid).template(template['template'])
    # request.reply.text "http://wendao.easybird.cn/results/my_videos?user=#{request[:FromUserName]}"

    Rails.logger.warn "SUBSCRIBE by: #{openid}"
    # date = Date.today.strftime("%Y-%m-%d")
    # date_str = Date.today.strftime("%-m月%-d日")
    # articles = { "articles" => [] }
    # articles["articles"] << {
    #   "title" => "熊猫AI #{date_str}关注",
    #   "description" => "熊猫AI扫描整个市场，每日早盘为您推荐今日看涨个股",
    #   "url" => "http://quant.ripple-tech.com/today?date=#{date}",
    #   # "url" => "http://quant.ripple-tech.com/#/NewRecommends?openid=#{openid}&date=#{date}",
    #   # "pic_url" => "https://mmbiz.qpic.cn/mmbiz_jpg/wc7YNPm3YxVWvjMZDPt1qVcs1oqibGH4S2ArnzuCWHNNYqgfaBbsqUtoQXG5D58r0uMPasMUlFFSfLl17HJvdXA/640?wx_fmt=jpeg&wxfrom=5&wx_lazy=1"
    #   "pic_url" => "https://api.dujin.org/bing/1366.php"
    #   }
    # wechat.custom_message_send Wechat::Message.to(openid).news(articles['articles'])
    # Rails.logger.warn "request: #{request}"
    # request.reply.success
    # Rails.logger.warn "request.reply.success"
  end

  on :event, with: 'unsubscribe' do |request|
    request.reply.success # user can not receive this message
  end

  # 当无任何 responder 处理用户信息时,使用这个 responder 处理
  on :fallback do |request|
    request.reply.success # request is XML result hash.
  end
end
