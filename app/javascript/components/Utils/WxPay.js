import React from 'react'

const WxPay = (props) => {

  return (

      WeixinJSBridge.invoke(
        'getBrandWCPayRequest', {
          "appId":props.state.data.appId,     //公众号名称，由商户传入
          "timeStamp":props.state.data.timeStamp,//时间戳，自1970年以来的秒数
          "nonceStr":props.state.data.nonceStr, //随机串
          "package":props.state.data.package, //预支付交易码
          "signType":props.state.data.signType,//微信签名方式：
          "paySign":props.state.data.paySign //微信签名
        },
        function(res){
          if(res.err_msg == "get_brand_wcpay_request:ok" ){
            alert("支付成功");
            that.props.history.push(RouterList.private)
            // 使用以上方式判断前端返回,微信团队郑重提示：
            //res.err_msg将在用户支付成功后返回ok，但并不保证它绝对可靠。
          }else{
            alert("支付失败,请重试")
          }
        }
      )

  )
}

export default WxPay
