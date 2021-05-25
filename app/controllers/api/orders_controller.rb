class Api::OrdersController < Api::ApplicationController
  skip_before_action :authenticate_user!, only: [:notify]

  def pre_pay
    m_requires! [:id]
    begin
      order = Order.find_by(id: params[:id])
      if params[:openid]
        openid = params[:openid]
      else
        openid = order.user.openid
      end
      result = [1, '下单失败', nil]
      ip = request.ip

      params = {
        body: order.package.title,
        out_trade_no: order.out_trade_no,
        # total_fee: (order.amount * 100).to_i,
        total_fee: 1,
        spbill_create_ip: ip,
        notify_url: 'http://pandaapi.ripple-tech.com/api/orders/notify',
        trade_type: 'JSAPI', # could be "MWEB", ""JSAPI", "NATIVE" or "APP",
        openid: openid # required when trade_type is `JSAPI`
      }
      r = WxPay::Service.invoke_unifiedorder params

      if r.success?
        params = {
          prepayid: r["prepay_id"], # fetch by call invoke_unifiedorder with `trade_type` is `JSAPI`
          noncestr: r["nonce_str"], # must same as given to invoke_unifiedorder
        }

        hash = WxPay::Service.generate_js_pay_req params
      end

      if hash
        result = [0, '下单成功', hash]
      end
    rescue Exception => ex
      result= [1, ex.message, nil]
    end
    render_json(result)
  end

  def notify
    result = Hash.from_xml(request.body.read)["xml"]
    order = Order.find_by(out_trade_no: result["out_trade_no"])

    if WxPay::Sign.verify?(result)
      if order.pay
        Subscription.transaction do
          user = order.user
          package = order.package
          start_date = user.subscriptions.maximum(:end_date).nil? ? Date.today : user.subscriptions.maximum(:end_date)
          end_date = start_date + package.date_num
          user.subscriptions.create!(start_date: start_date, end_date: end_date, package_type: package.package_type, watch_num: package.watch_num)
        end
      end
      render :xml => {return_code: "SUCCESS"}.to_xml(root: 'xml', dasherize: false)
    else
      order.cancel
      render :xml => {return_code: "FAIL", return_msg: "签名失败"}.to_xml(root: 'xml', dasherize: false)
    end
  end

end
