class NotificationJob < ApplicationJob
  queue_as :push_notifications

  after_perform :sms

  def perform(*args)
    @id = args[0]

    @notification = PushNotification.find(@id)

    if @notification
      begin
        openid = @notification.user.openid
        stock_analyse = @notification.stock_analyse
        url = "https://pandaapi.ripple-tech.com/stockanalysis/#{stock_analyse.id}"
        path = Rails.root.to_s + "/app/views/templates/find_w_notice.yml"
        template = YAML.load(File.read(path))
        template["template"]["url"] = url
        template["template"]["data"]["first"]["value"] = "您关注的：#{stock_analyse.stock_display_name}(#{stock_analyse.stock_code})已触发W形态"
        template["template"]["data"]["keyword1"]["value"] = stock_analyse.stock_display_name
        template["template"]["data"]["keyword2"]["value"] = "k线价格W形态"
        template["template"]["data"]["keyword3"]["value"] = "#{stock_analyse.duration == '1d' ? '日线' : '分钟线'}"
        template["template"]["data"]["keyword4"]["value"] = "#{stock_analyse.end_time.strftime('%Y-%m-%d %H:%M')}触发"
        template["template"]["data"]["remark"]["value"] = "点击本条提醒，查看详情"

        Wechat.api.template_message_send Wechat::Message.to(openid).template(template['template'])
      rescue Exception => ex
        @notification.failed
        Rails.logger.warn "#{ex.message}"
      end
    end
  end

  private
  def sms
    mobile = @notification.user.mobile
    if !mobile.nil? && !mobile.empty?
      begin
        stock_code = @notification.stock_code
        stock_display_name = @notification.stock_display_name
        duration = case @notification.duration
        when '1d'
          "日线"
        when '1m'
          "分钟线"
        end

        @var        = {}
        @var["stock_code"] = stock_code
        @var["stock_display_name"] = stock_display_name
        @var["duration"] = duration
        uri         = URI.parse("https://api.submail.cn/message/xsend.json")
        username    = ENV['SMS_APPID']
        password    = ENV['SMS_APPKEY']
        project     = ENV['SMS_PROJECT2']
        res         = Net::HTTP.post_form(uri, appid: username, to: mobile, project: project, signature: password, vars: @var.to_json)

        status      = JSON.parse(res.body)["status"]
      rescue  Exception => ex
        Rails.logger.warn "#{ex.message}"
      ensure
        if (status == "success")
          @notification.update(send_time: Time.now)
          @notification.sent
        else
          @notification.failed
        end
      end
    end
  end
end
