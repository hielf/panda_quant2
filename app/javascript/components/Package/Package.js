import React, { useState, useEffect, Fragment } from 'react'
import axios from 'axios'
import Header from './Header'
import PurchaseForm from './PurchaseForm'
import styled from 'styled-components'
import queryString from 'query-string'
// import { WxPay } from '../Utils/WxPay'

const Wrapper = styled.div`
  margin-left: auto;
  margin-right: auto;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
`

const Column = styled.div`
  background: #fff;
  height: 100vh;
  overflow: scroll;

  &:last-child {
    background: #000;
  }
`

const Main = styled.div`
  padding-left: 50px;
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
      }
      console.log(resp.data)
      const order_id = resp.data.data.id
      axios.post('/api/orders/pre_pay', {"id": order_id}, {
        headers: headers
      })
      .then(resp => {
        debugger
        console.log(resp.data)
        setOrder(resp.data.data)
        WeixinJSBridge.invoke(
          'getBrandWCPayRequest', {
            "appId":order.appId,     //公众号名称，由商户传入
            "timeStamp":order.timeStamp,//时间戳，自1970年以来的秒数
            "nonceStr":order.nonceStr, //随机串
            "package":order.package, //预支付交易码
            "signType":order.signType,//微信签名方式：
            "paySign":order..paySign //微信签名
          },
          function(res){
            if(res.err_msg == "get_brand_wcpay_request:ok" ){
              alert("支付成功");
              // that.props.history.push(RouterList.private);
              // 使用以上方式判断前端返回,微信团队郑重提示：
              //res.err_msg将在用户支付成功后返回ok，但并不保证它绝对可靠。
            }else{
              alert("支付失败,请重试");
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
            </Main>
          </Column>
          <Column>
            <PurchaseForm
              handleChange={handleChange}
              handleSubmit={handleSubmit}
              attributes={packagee.data.package}
            />
          </Column>
        </Fragment>
      }
    </Wrapper>
  )
}

export default Package
