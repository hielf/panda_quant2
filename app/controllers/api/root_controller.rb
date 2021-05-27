module Api
  class RootController < Api::ApplicationController
    skip_before_action :authenticate_user!

    def route_not_found
      # raise ActiveRecord::RecordNotFound
      render_json([404, 'Request page not found'])
    end

    def home
      render_json([0, 'ok'])
    end

    def wechat_access_token
      c = Wechat::ApiLoader.config(:default)
      token_file = c.access_token.presence
      js_token_file = c.jsapi_ticket.presence
      api = Wechat::Api.new(c.appid, c.secret, token_file, c.timeout, c.skip_verify_ssl, js_token_file)
      api.users
      config_file = Rails.root.join('config/wechat.yml')
      wechat_config = YAML.load(ERB.new(File.read(config_file)).result)
      f = File.read(wechat_config["production"]["access_token"])
      # f = File.read(wechat_config["production"]["jsapi_ticket"])
      data = JSON.parse(f)
      access_token = data["access_token"]
      url = "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=#{access_token}&type=jsapi"
      res = HTTParty.get url
      jsapi_ticket = JSON.parse(res.body)
      data["ticket"] = jsapi_ticket["ticket"]
      if jsapi_ticket["ticket"]
        timestamp = Time.now.to_i.to_s
        url = params[:url].blank? ? "http://pandaapi.ripple-tech.com/" : params[:url]
        ticket = jsapi_ticket["ticket"]
        noncestr = (0...16).map { (('a'..'z').to_a + ('A'..'Z').to_a)[rand(58)] }.join
        s = "jsapi_ticket=#{jsapi_ticket["ticket"]}&noncestr=#{noncestr}&timestamp=#{timestamp}&url=#{url}"
        signature = Digest::SHA1.hexdigest s
        data["appId"] = c.appid.to_s
        data["timestamp"] = timestamp
        data["nonceStr"] = noncestr
        data["signature"] = signature
      end

      render_json([0, 'ok', data])
    end

    def wechat_get_token
      config_file = Rails.root.join('config/wechat.yml')
      wechat_config = YAML.load(ERB.new(File.read(config_file)).result)

      appid = wechat_config["production"]["appid"]
      secret = wechat_config["production"]["secret"]
      code = params[:code]

      url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{appid}&secret=#{secret}&code=#{code}&grant_type=authorization_code"

      res = HTTParty.get url
      json = JSON.parse(res.body)

      if json["errcode"]
        render_json([1, 'error', json])
      else
        render_json([0, 'ok', json])
      end
    end

    def wechat_userinfo
      config_file = Rails.root.join('config/wechat.yml')
      wechat_config = YAML.load(ERB.new(File.read(config_file)).result)

      appid = wechat_config["production"]["appid"]
      secret = wechat_config["production"]["secret"]
      code = params[:code]
      #2
      url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{appid}&secret=#{secret}&code=#{code}&grant_type=authorization_code"

      res = HTTParty.get url
      json = JSON.parse(res.body)

      # access_token = params[:access_token]
      # openid = params[:openid]
      # url = "https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=#{appid}&grant_type=refresh_token&refresh_token=REFRESH_TOKEN"

      access_token = json["access_token"]
      refresh_token = json["refresh_token"]
      openid = json["openid"]
      #3
      url = "https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=#{appid}&grant_type=refresh_token&refresh_token=#{refresh_token}"

      res = HTTParty.get url
      json = JSON.parse(res.body)
      access_token = json["access_token"]

      #4
      url = "https://api.weixin.qq.com/sns/userinfo?access_token=#{access_token}&openid=#{openid}&lang=zh_CN"
      res = HTTParty.get url
      json = JSON.parse(res.body)

      if json["errcode"]
        render_json([1, 'error', json])
      else
        render_json([0, 'ok', json])
      end
    end

    def miniprogram_openid
      config_file = Rails.root.join('config/wechat.yml')
      wechat_config = YAML.load(ERB.new(File.read(config_file)).result)

      appid = wechat_config["production"]["mini_appid"]
      secret = wechat_config["production"]["mini_secret"]
      code = params[:code]
      #2
      url = "https://api.weixin.qq.com/sns/jscode2session?appid=#{appid}&secret=#{secret}&js_code=#{code}&grant_type=authorization_code"

      res = HTTParty.get url
      json = JSON.parse(res.body)

      # access_token = params[:access_token]
      # openid = params[:openid]
      # url = "https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=#{appid}&grant_type=refresh_token&refresh_token=REFRESH_TOKEN"

      access_token = json["access_token"]
      refresh_token = json["refresh_token"]
      openid = json["openid"]
      #3
      # url = "https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=#{appid}&grant_type=refresh_token&refresh_token=#{refresh_token}"
      #
      # res = HTTParty.get url
      # json = JSON.parse(res.body)
      # access_token = json["access_token"]
      #
      # #4
      # url = "https://api.weixin.qq.com/sns/userinfo?access_token=#{access_token}&openid=#{openid}&lang=zh_CN"
      # res = HTTParty.get url
      # json = JSON.parse(res.body)
      @user = User.find_or_create_by(openid: openid)
      status, message = @user.login("mini", request.ip) if @user
      if status
        cookies[:token] = { :value => @user.access_token, :expires => Time.now + 360.days }
        cookies[:mobile] = { :value => @user.mobile, :expires => Time.now + 360.days }
      end

      info = {:wechat_access_token=>access_token, :openid=>openid, :refresh_token=>refresh_token, :access_token=>@user.access_token}

      if json["errcode"]
        render_json([1, 'error', json])
      else
        render_json([0, 'ok', info])
      end
    end

    # def wechat_sign
    #   if jsapi_ticket["ticket"]
    #     timestamp = Time.now.to_i.to_s
    #
    #
    #   end
    # end

  end
end
