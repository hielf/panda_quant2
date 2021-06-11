import React, { useState, useEffect, Fragment } from 'react'
import axios from 'axios'
import Header from './Header'
import PurchaseForm from './PurchaseForm'
import styled from 'styled-components'
import queryString from 'query-string'

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
  const [loaded, setLoaded] = useState(false)
  const [iswechat, setIswechat] = useState(navigator.userAgent.toLowerCase().indexOf('micromessenger') !== -1 || typeof navigator.wxuserAgent != "undefined")

  useEffect(() => {
    // console.log(props)
    const parsed = queryString.parse(props.location.search);
    const url = '/api/wechat_userinfo'

    axios.get(url, {
      params: {
        code: parsed.code
      }
    })
    .then( resp => {
      if (iswechat == false) {
        alert("请在微信打开链接")
      }
      setWxinfo(resp.data)
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
    const openid = "oEJU4v32gZGQlCMCuUmZMDNgxUHs" //wxinfo.data.openid
    axios.post('/api/packages/subscribe', {package_id, openid})
    .then(resp => {
      if (resp.data.status != 0) {
        alert("用户未验证");
      }
      console.log(resp.data);
      // setOrder(resp.data)
      const order_id = resp.data.data.id
      axios.post('/api/orders/pre_pay', {"id": order_id})
      .then(resp => {
        console.log(resp.data);
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
