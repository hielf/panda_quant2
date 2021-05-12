class WechatsController < ApplicationController
  # For details on the DSL available within this file, see https://github.com/Eric-Guo/wechat#wechat_responder---rails-responder-controller-dsl
  wechat_responder

  on :text do |request, content|
    request.reply.text "欢迎使用熊猫宽客,请选择下方菜单开始" # Just echo
  end

  # When user click the menu button
  on :click, with: 'SUBSCRIBE' do |request, key|
    # request.reply.text "http://wendao.easybird.cn/results/my_videos?user=#{request[:FromUserName]}"
    openid = request[:FromUserName]
    Rails.logger.warn "SUBSCRIBE by: #{openid}"
    date = Date.today.strftime("%Y-%m-%d")
    date_str = Date.today.strftime("%-m月%-d日")
    articles = { "articles" => [] }
    articles["articles"] << {
      "title" => "熊猫AI #{date_str}关注",
      "description" => "熊猫AI扫描整个市场，每日早盘为您推荐今日看涨个股",
      "url" => "http://quant.ripple-tech.com/today?date=#{date}",
      # "url" => "http://quant.ripple-tech.com/#/NewRecommends?openid=#{openid}&date=#{date}",
      # "pic_url" => "https://mmbiz.qpic.cn/mmbiz_jpg/wc7YNPm3YxVWvjMZDPt1qVcs1oqibGH4S2ArnzuCWHNNYqgfaBbsqUtoQXG5D58r0uMPasMUlFFSfLl17HJvdXA/640?wx_fmt=jpeg&wxfrom=5&wx_lazy=1"
      "pic_url" => "https://api.dujin.org/bing/1366.php"
      }
    wechat.custom_message_send Wechat::Message.to(openid).news(articles['articles'])
    Rails.logger.warn "custom_message_sended"
    Rails.logger.warn "request: #{request}"
    request.reply.success
    Rails.logger.warn "request.reply.success"
  end

  # Any not match above will fail to below
  on :fallback, respond: 'fallback message'

end