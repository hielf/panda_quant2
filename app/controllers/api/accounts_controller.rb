# encoding: utf-8
class Api::AccountsController < Api::ApplicationController
  # include ApplicationHelper
  skip_before_action :authenticate_user!, only: [:sign_in, :miniprogram_sign_in, :simple_sign_in]

  def sign_in
    m_requires! [:mobile, :verify_code]
    @user = User.find_or_create_by(mobile: params[:mobile])
    @user.update(openid: params[:openid]) if !params[:openid].blank?

    status, message = @user.login(params[:verify_code], request.ip)
    if status
      cookies[:token] = { :value => @user.access_token, :expires => Time.now + 180.days}
      cookies[:mobile] = { :value => @user.mobile, :expires => Time.now + 180.days}
      # cookies[:openid] = { :value => @user.openid, :expires => Time.now + 180.days}
      @user
    else
      render_json([401, message])
    end
  end

  def miniprogram_sign_in
    m_requires! [:openid, :sessionkey, :encrypteddata, :iv]
    config_file = Rails.root.join('config/wechat.yml')
    wechat_config = YAML.load(ERB.new(File.read(config_file)).result)
    appId = wechat_config["default"]["mini_appid"]

    sessionKey = params[:sessionkey]
    encryptedData = params[:encrypteddata]
    iv = params[:iv]
    openid = params[:openid]

    user_data = helpers.wxdata_decrypt_ruby(appId, sessionKey, encryptedData, iv)
    mobile = user_data["purePhoneNumber"]

    @user = User.find_or_create_by(openid: openid)
    @user.mobile = mobile

    status, message = @user.login("mini", request.ip) if @user
    if status
      cookies[:token] = { :value => @user.access_token, :expires => Time.now + 360.days}
      cookies[:mobile] = { :value => @user.mobile, :expires => Time.now + 360.days}
      # cookies[:openid] = { :value => @user.openid, :expires => Time.now + 180.days}
      render_json([0, '登录成功', @user])
    else
      render_json([401, message])
    end
  end

  def simple_sign_in
    m_requires! [:openid]

    openid = params[:openid]
    @user = User.find_or_create_by(openid: openid)

    status, message = @user.login("mini", request.ip) if @user
    if status
      cookies[:token] = { :value => @user.access_token, :expires => Time.now + 360.days}
      cookies[:mobile] = { :value => @user.mobile, :expires => Time.now + 360.days}
      # cookies[:openid] = { :value => @user.openid, :expires => Time.now + 180.days}
      render_json([0, '登录成功', @user])
    else
      render_json([401, message])
    end
  end

  def sign_out
    if current_user.update(access_token: nil)
      result =[0, '登出成功']
    else
      result =[1, '登出失败']
    end
    render_json(result)
  end

end
