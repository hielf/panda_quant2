class Api::PackagesController < Api::ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :subscribe, :new_user_package]

  def create
    m_requires! [:title, :period, :market_price, :discount, :real_price, :package_type, :desc]
    begin
      package = Package.find_or_initialize_by(package_params)
      if package.save!
        result = [0, '接收成功']
      else
        result = [1, '接收失败']
      end
    rescue Exception => ex
      result= [1, ex.message]
    end
    render_json(result)
  end

  def index
    optional! :page, default: 1
    optional! :per, default: 20, values: 1..100
    @q = Package.ransack()
    @packages = @q.result.order(period: :desc)
  end

  def show
    m_requires! [:id]
    @package = Package.find_by(id: params[:id])
  end

  def subscribe
    m_requires! [:package_id]
    begin
      package = Package.find_by(id: params[:package_id])
      result = [1, '订阅下单失败', nil]
      current_user = User.find_by(openid: params[:openid]) if !params[:openid].to_s.blank?
      Order.transaction do
        order = current_user.orders.new(package_id: package.id, amount: package.real_price, out_trade_no: current_user.id.to_s + "_" + Time.now.to_i.to_s)
        if order.save!
          result = [0, '订阅下单成功', order]
        end
      end
    rescue Exception => ex
      result= [1, ex.message, nil]
    end
    render_json(result)
  end

  def new_user_package
    begin
      package = Package.find_by(package_type: "新手礼包")
      result = '领取失败'
      current_user = User.find_by(openid: params[:openid]) if !params[:openid].to_s.blank?

      if had_subscribtion?(package)
        result = '很抱歉，您已领取过新用户礼包福利'
      else
        Subscribtion.transaction do
          start_date = Date.today
          end_date = start_date + package.date_num
          current_user.subscribtions.create!(start_date: start_date, end_date: end_date, package_type: package.package_type, watch_num: package.watch_num, note:package.desc)
        end
        result = "新用户礼包领取成功，您将在5个交易日内任意沪深300成份股票出现W形态买点时获得提醒"
      end
    rescue Exception => ex
      result= ex.message
    end
    Wechat.api.custom_message_send Wechat::Message.to(params[:openid]).text(result)
  end

  private

  def package_params
    params.permit(:title, :period, :market_price, :discount, :real_price, :package_type, :desc)
  end

end
