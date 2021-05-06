class Sm < ApplicationRecord
  validates :mobile, presence: true, length: {minimum: 11, maximum: 13}, on: :create
  validates :generate_verify_code, presence: true, on: :create

  def generate_verify_code
    self.verify_code = rand(1000..9999)
  end

  def send_code(str)
    return false unless mobile && mobile.to_s.length >= 11
    return false unless sign(mobile) == str

    @var        = {}
    @var["code"] = verify_code
    uri         = URI.parse("https://api.submail.cn/message/xsend.json")
    username    = ENV['SMS_APPID']
    password    = ENV['SMS_APPKEY']
    project     = ENV['SMS_PROJECT']
    res         = Net::HTTP.post_form(uri, appid: username, to: mobile, project: project, signature: password, vars: @var.to_json)

    status      = JSON.parse(res.body)["status"]
    if (status == "success")
      return verify_code
    else
      false
    end
  end

private
  def sign(mobile)
    Digest::MD5.hexdigest(mobile.last(4))
  end
end
