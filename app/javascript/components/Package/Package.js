import React, { useState, useEffect, Fragment } from 'react'
import axios from 'axios'
import Header from './Header'
import PurchaseForm from './PurchaseForm'
import styled from 'styled-components'

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
  const [openid, setOpenid] = useState({})
  const [code, setCode] = useState({})
  const [loaded, setLoaded] = useState(false)
  const [iswechat, setIswechat] = useState(navigator.userAgent.toLowerCase().indexOf('micromessenger') !== -1 || typeof navigator.wxuserAgent != "undefined")

  useEffect(() => {
    const token = "123"

    const url = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx74920a351435caa9&redirect_uri=http://pandaapi.ripple-tech.com/&response_type=code&scope=snsapi_base&state=STATE#wechat_redirect'

    axios.defaults.headers.common = {
      ...axios.defaults.headers.common,
      'Access-Control-Allow-Origin': 'http://localhost:3000',
      "Content-Type": 'application/json',
      "Authorization": token ? `Token ${token}` : undefined
   };
   axios.defaults.preflightContinue = true;
   //axios.defaults.crossDomain = true;
   axios.defaults.withCredentials = !!token;

    axios.get(url)
    .then( resp => {
      setCode(resp.data)
      console.log(resp)
      console.log(code)
    } )
    .catch( resp => console.log(resp) )
  }, [])

  useEffect(() => {
    const url = '/api/wechat_userinfo'

    axios.get(url)
    .then( resp => {
      setOpenid(resp.data)
      console.log(resp)
      console.log(openid)
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

    const csrfToken = document.querySelector('[name=csrf-token]').content
    axios.defaults.headers.common['X-CSRF-TOKEN'] = csrfToken
    const package_id = packagee.data.package.id
    axios.post('/api/packages/subscribe', {package_id})
    .then(resp => {
      if (resp.data.status == 401) {
        alert("用户未验证");
      }
      console.log(resp.data);
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
