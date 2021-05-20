class WechatsController < ApplicationController
  # For details on the DSL available within this file, see https://github.com/Eric-Guo/wechat#wechat_responder---rails-responder-controller-dsl
  wechat_responder

  # 验证手机号
  on :text, with: /^1[3-9]\d{9}$/ do |request|
    openid = request[:FromUserName]
    content = request[:Content]
    # if content.match(/^1[3-9]\d{9}$/)
    #   true
    # end
    request.message_hash.each do |key, value|
      Rails.logger.warn "#{key}: #{value}"
    end
    wechat.custom_message_send Wechat::Message.to(openid).text("已发送短信验证码至手机号码：#{content}\n请在下方的对话栏内回复6位数字验证码")
    # request.reply.text "已发送短信验证码至手机号码：#{content}/n请在下方的对话栏内回复6位数字验证码"
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

  # 当无任何 responder 处理用户信息时,使用这个 responder 处理
  on :fallback do |request|
    request.reply.success # request is XML result hash.
  end
end
