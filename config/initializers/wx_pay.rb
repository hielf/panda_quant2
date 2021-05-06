# required
WxPay.appid = ENV['wechat_appid']
WxPay.key = ENV['wechat_pay_key']
WxPay.mch_id = ENV['wechat_pay_mch']
WxPay.debug_mode = true # default is `true`
WxPay.sandbox_mode = false # default is `false`

# cert, see https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=4_3
# using PCKS12
WxPay.set_apiclient_by_pkcs12(File.read('/var/www/panda_quant2/shared/config/cert/apiclient_cert.p12'), ENV['wechat_pay_mch']) if Rails.env == "production"

# if you want to use `generate_authorize_req` and `authenticate`
WxPay.appsecret = ENV['wachat_appsecret']

# optional - configurations for RestClient timeout, etc.
WxPay.extra_rest_client_options = {timeout: 2, open_timeout: 3}
