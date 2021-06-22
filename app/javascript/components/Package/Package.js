import React, { useState, useEffect, Fragment } from 'react'
import axios from 'axios'
import Header from './Header'
import PurchaseForm from './PurchaseForm'
import styled from 'styled-components'
import queryString from 'query-string'
// import { WxPay } from '../Utils/WxPay'

const Wrapper = styled.div`
  background: #fec107;
  margin: 5px 5px;
  padding: 1px;
`

const Column = styled.div`
  background: #fff;
  height: 95vh;
  overflow: scroll;
`

const Main = styled.div`
  padding: 0;
`

const Package = (props) => {
  const [packagee, setPackagee] = useState({})
  const [order, setOrder] = useState({})
  const [wxinfo, setWxinfo] = useState({})
  const [login, setLogin] = useState({})
  const [loaded, setLoaded] = useState(false)
  const [iswechat, setIswechat] = useState(navigator.userAgent.toLowerCase().indexOf('micromessenger') !== -1 || typeof navigator.wxuserAgent != "undefined")
  const parsed = queryString.parse(props.location.search)

  useEffect(() => {
    const url = '/api/wechat_userinfo'

    axios.get(url, {
      params: {
        code: parsed.code
      }
    })
    .then( resp => {
      setWxinfo(resp.data.data)
      console.log(resp.data)
      console.log(wxinfo)
      if (iswechat == false) {
        alert("请在微信打开链接")
      }

      const openid = resp.data.data.openid
      // const openid = 'oEJU4v32gZGQlCMCuUmZMDNgxUHs'
      axios.post('/api/accounts/simple_sign_in', {"openid": openid})
      .then(resp => {
        console.log(resp.data)
        setLogin(resp.data.data)
      })
      .catch(function (error) {
        console.log(error)
      })
    } )
    .catch( resp => console.log(resp) )
  }, [])

  useEffect(() => {
    const id = props.match.params.id
    const url = '/api/packages/' + id

    axios.get(url)
    .then( resp => {
      setPackagee(resp.data)
      setLoaded(true)
    } )
    .catch( resp => console.log(resp) )
  }, [])

  const handleChange = (e) => {
    e.preventDefault()
  }

  const handleSubmit = (e) => {
    e.preventDefault()

    const headers = {
      Authorization: `Token token=${login.access_token},mobile=${login.mobile}`
    }
    const csrfToken = document.querySelector('[name=csrf-token]').content
    axios.defaults.headers.common['X-CSRF-TOKEN'] = csrfToken
    const package_id = packagee.data.package.id
    const openid = wxinfo.openid
    // const openid = 'oEJU4v32gZGQlCMCuUmZMDNgxUHs'
    axios.post('/api/packages/subscribe', {package_id, openid}, {
      headers: headers
    })
    .then(resp => {
      if (resp.data.status != 0) {
        alert("用户未验证")
        // props.history.push('/package/success')
      }
      console.log(resp.data)
      const order_id = resp.data.data.id
      axios.post('/api/orders/pre_pay', {"id": order_id}, {
        headers: headers
      })
      .then(resp => {
        console.log(resp.data)
        // setOrder(resp.data.data)
        WeixinJSBridge.invoke(
          'getBrandWCPayRequest', {
            "appId":resp.data.data.appId,     //公众号名称，由商户传入
            "timeStamp":resp.data.data.timeStamp,//时间戳，自1970年以来的秒数
            "nonceStr":resp.data.data.nonceStr, //随机串
            "package":resp.data.data.package, //预支付交易码
            "signType":resp.data.data.signType,//微信签名方式：
            "paySign":resp.data.data.paySign //微信签名
          },
          function(res){
            if(res.err_msg == "get_brand_wcpay_request:ok" ){
              location.replace(`/subscribtion/${package_id}`)
              // that.props.history.push(RouterList.private);
              // 使用以上方式判断前端返回,微信团队郑重提示：
              //res.err_msg将在用户支付成功后返回ok，但并不保证它绝对可靠。
            }else{
              alert("支付失败,请重试")
            }
          }
        );
        // WxPay.onBridgeReady(resp.data)
      })
      .catch(function (error) {
        console.log(error);
      });
    })
    .catch(function (error) {
      console.log(error);
    });
  }

  return (
    <Wrapper>
      {
        loaded &&
        <Fragment>
          <Column>
            <Main>
              <Header
                attributes={packagee.data.package}
              />
              <div className="desc"></div>
              <PurchaseForm
                handleChange={handleChange}
                handleSubmit={handleSubmit}
                attributes={packagee.data.package}
              />
            </Main>
          </Column>
        </Fragment>
      }
    </Wrapper>
  )
}

export default Package
