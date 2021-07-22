class WechatsController < ApplicationController
  # For details on the DSL available within this file, see https://github.com/Eric-Guo/wechat#wechat_responder---rails-responder-controller-dsl
  wechat_responder

  on :event, with: 'subscribe' do |request|
    openid = request[:FromUserName]
    new_user = Wechat.api.user openid
    nickname = new_user["nickname"]
    avatar = new_user["headimgurl"]
    user = User.find_or_initialize_by(openid: openid)
    if user.save!
      user.update(nickname: nickname, avatar: avatar)
    end
    url = "https://pandaapi.ripple-tech.com/api/packages/new_user_package?openid=#{openid}"
    wechat.custom_message_send Wechat::Message.to(openid).text("欢迎关注本工具:\na)我们为您实时扫描订阅的证券行情\nb)在W形态买入点出现时向您发出通知")
    wechat.custom_message_send Wechat::Message.to(openid).text("请按👇\n【联系反馈】\n【新用户礼包】\n\n获取免费5个交易日的新用户福利🔥\n包含沪深300成份股票的日线级别提醒📈")

    request.reply.success
    user.op("event", "subscribe") if user
  end

  #new user package
  on :click, with: 'NEWUSER' do |request, key|
    openid = request[:FromUserName]
    new_user = Wechat.api.user openid
    nickname = new_user["nickname"]
    avatar = new_user["headimgurl"]
    user = User.find_or_initialize_by(openid: openid)
    if user.save!
      user.update(nickname: nickname, avatar: avatar)
    end

    if user
      url = "https://pandaapi.ripple-tech.com/api/packages/new_user_package?openid=#{openid}"
      res = HTTParty.get url
      json = JSON.parse(res.body)

      if user.mobile.nil? || user.mobile.empty?
        wechat.custom_message_send Wechat::Message.to(openid).text("您可以在微信对话栏回复手机号，以便获取短信通知\n本公众号承诺不会向您发送除W形态报告以外的任何消息")
      end
    end

    request.reply.success
    user.op("click", "newuser") if user
  end

  # 验证手机号
  on :text, with: /^1[3-9]\d{9}$/ do |request|
    openid = request[:FromUserName]
    mobile = request[:Content]
    user = User.find_by(openid: openid)
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
    user.op("text", mobile) if user
    # request.reply.text "已发送短信验证码至手机号码：#{content}/n请在下方的对话栏内回复6位数字验证码"
  end

  # 验证码
  on :text, with: /^\d{4}$/ do |request|
    openid = request[:FromUserName]
    verify_code = request[:Content]
    user = User.find_by(openid: openid)
    reply = ""

    request.message_hash.each do |key, value|
      Rails.logger.warn "#{key}: #{value}"
    end

    last_sm = Sm.where("message = ? AND message_type = ? AND created_at > ?", verify_code, "verify_code", 5.minutes.ago).last
    if last_sm
      user.update(mobile: last_sm.mobile)
      reply = "验证通过，已为您绑定接收通知的手机"
    else
      reply = "您输入的验证码有误，请重新输入或再次输入手机号获取验证码"
    end

    request.reply.text reply
    user.op("text", verify_code) if user
  end

  #subscribe
  on :click, with: 'SUBSCRIBE' do |request, key|
    openid = request[:FromUserName]
    user = User.find_by(openid: openid)

    if ApplicationController.helpers.has_subscribe(user)
      subscribtion = user.current_subscribtion
      package_type = subscribtion.nil? ? "未订阅" : subscribtion.package_type
      # package = Package.find_by(package_type: subscribtion.package_type)
      user_stock_list = user.vaild_stock_lists
      rest_watch_num = subscribtion.nil? ? 0 : (subscribtion.watch_num - user_stock_list.count)
      wechat.custom_message_send Wechat::Message.to(openid).text("您当前使用的套餐：#{package_type}\n已订阅数量：#{user_stock_list.count}\n剩余可订阅数量：#{rest_watch_num}")
      wechat.custom_message_send Wechat::Message.to(openid).text("请回复下列序号操作：\n3. 继续订阅\n4. 查询当前订阅列表\n5. 删除订阅")
    else
      wechat.custom_message_send Wechat::Message.to(openid).text("请先选择您的【套餐】,限时最低0.01元起")
    end
    # request.reply.text "User: #{request[:FromUserName]} click #{key}"

    request.reply.success
    user.op("click", "SUBSCRIBE") if user
  end

  #package
  on :click, with: 'PACKAGE' do |request, key|
    openid = request[:FromUserName]
    user = User.find_by(openid: openid)

    packages = user.subscribtions
    reply = "您当前的套餐："
    packages.to_enum.with_index(1).each do |pa, index|
      reply = reply + "#{"\n" unless reply.empty?}" +
        "#{index.to_s}. 【#{pa.package_type}】 关注上限： #{pa.watch_num}" +
        "\n有效期： #{pa.start_date} 至 #{pa.end_date}"
    end

    wechat.custom_message_send Wechat::Message.to(openid).text("新用户请直接选择需要的套餐\n老用户可以在已有订阅的基础上叠加新套餐\n详细说明请查看【帮助】")
    wechat.custom_message_send Wechat::Message.to(openid).text("#{reply}") if !packages.empty?
    wechat.custom_message_send Wechat::Message.to(openid).text("请选择您的套餐：\n1. 基础套餐(关注上限10个代码)\n2. 高级套餐(关注上限50个代码)")
    # request.reply.text "User: #{request[:FromUserName]} click #{key}"

    request.reply.success
    user.op("click", "PACKAGE") if user
  end

  # 指令操作 Level 1
  on :text, with: /^\d{1}$/ do |request|
    openid = request[:FromUserName]
    op = request[:Content]
    user = User.find_by(openid: openid)
    subscribtion = user.current_subscribtion
    flag = true

    request.message_hash.each do |key, value|
      Rails.logger.warn "#{key}: #{value}"
    end

    last_op_type, last_op_message  = user.last_op

    config_file = Rails.root.join('config/wechat.yml')
    wechat_config = YAML.load(ERB.new(File.read(config_file)).result)
    appid = wechat_config["production"]["appid"]

    if op == "1"
      packages = Package.where(package_type: "基础套餐")
      reply = ""
      packages.to_enum.with_index(11).each do |pa, index|
        url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{appid}&redirect_uri=http://pandaapi.ripple-tech.com/package/#{pa.id.to_s}&response_type=code&scope=snsapi_base&state=#{pa.id.to_s}#wechat_redirect"
        reply = reply + "#{"\n" unless reply.empty?}" +
          "#{index.to_s}. <a href='#{url}'>【#{pa.title}】</a>" +
          "-- #{pa.real_price > 1 ? pa.real_price.to_i.to_s : pa.real_price.to_s} 元" +
          "\n(#{pa.desc})"
      end
      wechat.custom_message_send Wechat::Message.to(openid).text(reply)

    elsif op == "2"
      packages = Package.where(package_type: "高级套餐")
      reply = ""
      packages.to_enum.with_index(21).each do |pa, index|
        url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{appid}&redirect_uri=http://pandaapi.ripple-tech.com/package/#{pa.id.to_s}&response_type=code&scope=snsapi_base&state=#{pa.id.to_s}#wechat_redirect"
        reply = reply + "#{"\n" unless reply.empty?}" +
          "#{index.to_s}. <a href='#{url}'>【#{pa.title}】</a>" +
          "-- #{pa.real_price > 1 ? pa.real_price.to_i.to_s : pa.real_price.to_s} 元" +
          "\n(#{pa.desc})"
      end
      wechat.custom_message_send Wechat::Message.to(openid).text(reply)

    elsif op == "3" && subscribtion #订阅
      current_watch = user.vaild_stock_lists.count
      watch_num = subscribtion.watch_num
      wechat.custom_message_send Wechat::Message.to(openid).text("当前订阅数：#{current_watch.to_s}/#{watch_num.to_s}\n请输入6位股票代码")

    elsif op == "4" #查看
      stock_lists = user.vaild_stock_lists
      if stock_lists.empty?
        reply = "您还没关注任何股票，请输入6位代码订阅"
      else
        reply = "您当前订阅的股票代码："
        stock_lists.to_enum.with_index(1).each do |sl, index|
          url = "https://wzq.tenpay.com/mp/v2/index.html?stat=#/trade/stock_detail.shtml?scode=#{sl.stock_code}&type=1&holder=&frombroker=&remindtype=choose"
          reply = reply + "#{"\n" unless reply.empty?}" +
            "#{index.to_s}.".ljust(4, ' ') +
            "#{sl.stock_display_name.ljust(6, ' ')}(<a href='#{url}'>" +
            "#{sl.stock_code}</a>)"
          if index % 5 == 0
            wechat.custom_message_send Wechat::Message.to(openid).text(reply)
            reply = ""
            sleep 0.1
          end
        end
        # rest of reply
        wechat.custom_message_send Wechat::Message.to(openid).text(reply.slice(0..682))
      end

    elsif op == "5" #“删除”
      wechat.custom_message_send Wechat::Message.to(openid).text("回复6位股票代码删除")
    else
      wechat.custom_message_send Wechat::Message.to(openid).text("您回复的指令有误，请重新输入")
      flag = false
    end

    request.reply.success
    # request.reply.text "已发送短信验证码至手机号码：#{content}/n请在下方的对话栏内回复6位数字验证码"
    user.op("text", op) if user && flag
  end

  # 股票代码
  on :text, with: /^\d{6}$/ do |request|
    openid = request[:FromUserName]
    op = request[:Content]
    user = User.find_by(openid: openid)
    flag = false
    stock = StockList.find_by(stock_code: op)
    subscribtion = user.current_subscribtion
    available_num = subscribtion.watch_num - user.vaild_stock_lists.count

    request.message_hash.each do |key, value|
      Rails.logger.warn "#{key}: #{value}"
    end

    last_op_type, last_op_message  = user.last_op

    if stock && subscribtion && available_num > 0
      if last_op_type == "text" && (last_op_message == "3" || last_op_message == "4")
        user.subscribe!(stock)
        wechat.custom_message_send Wechat::Message.to(openid).text("已订阅：#{stock.stock_display_name}(#{stock.stock_code})\n剩余可订阅数量：#{(available_num - 1).to_s}")
      elsif last_op_type == "text" && last_op_message == "5"
        if user.subscribing?(stock)
          user.unsubscribe!(stock)
          wechat.custom_message_send Wechat::Message.to(openid).text("已删除：#{stock.stock_display_name}(#{stock.stock_code})\n剩余可订阅数量：#{(available_num + 1).to_s}")
        else
          wechat.custom_message_send Wechat::Message.to(openid).text("您未订阅该股票，请检查输入的代码是否正确")
        end
      end

    elsif stock.nil?
      wechat.custom_message_send Wechat::Message.to(openid).text("对不起，您输入的股票代码可能有误，请重新输入或联系客服")
    elsif available_num == 0
      wechat.custom_message_send Wechat::Message.to(openid).text("对不起，您的订阅数量已达到当前套餐上限")
    else
      wechat.custom_message_send Wechat::Message.to(openid).text("您回复的指令有误，请重新输入")
    end

    request.reply.success
    # request.reply.text "已发送短信验证码至手机号码：#{content}/n请在下方的对话栏内回复6位数字验证码"
    user.op("text", op) if user && flag
  end

  #help
  on :click, with: 'HELP' do |request, key|
    openid = request[:FromUserName]
    user = User.find_by(openid: openid)

    wechat.custom_message_send Wechat::Message.to(openid).text("本工具提供：\n1. 监测日线行情股票走势\n2. 当被关注的股票出现<a href='https://zhuanlan.zhihu.com/p/101289251'>W形态行情</a>时，发送短信、微信通知")
    wechat.custom_message_send Wechat::Message.to(openid).text("3.订阅成功后，订阅期限将自动延长\n4.如续期变更套餐的，在新套餐开始前延续现有套餐的关注上限，在新套餐生效后会自动转为新的关注上限")

    # request.reply.text "User: #{request[:FromUserName]} click #{key}"
    request.reply.success
    user.op("click", "HELP") if user
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
    openid = request[:FromUserName]
    user = User.find_by(openid: openid)

    request.reply.success # user can not receive this message
    user.op("event", "unsubscribe") if user
  end

  # 当无任何 responder 处理用户信息时,使用这个 responder 处理
  on :fallback do |request|
    openid = request[:FromUserName]
    user = User.find_by(openid: openid)

    wechat.custom_message_send Wechat::Message.to(openid).text("请选择菜单下的功能进行操作")
    request.reply.success # request is XML result hash.
    user.op("fallback", request[:Content]) if user
  end
end
