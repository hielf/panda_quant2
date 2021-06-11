import React, { useState, useEffect, Fragment } from 'react'
import axios from 'axios'
import Header from './Header'
import PayForm from './PayForm'
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

const Order = (props) => {
  const [order, setOrder] = useState({})
  const [loaded, setLoaded] = useState(false)
  const [iswechat, setIswechat] = useState(navigator.userAgent.toLowerCase().indexOf('micromessenger') !== -1 || typeof navigator.wxuserAgent != "undefined")

  useEffect(() => {
    const id = props.match.params.id
    const url = '/api/orders/' + id

    axios.get(url)
    .then( resp => {
      setOrder(resp.data)
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
    const order_id = order.data.package.id
    axios.post('/api/orders/pre_pay', {order_id})
    .then(resp => {
      if (resp.data.status != 0) {
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
                attributes={order.data.order}
              />
              <div className="desc"></div>
            </Main>
          </Column>
          <Column>
            <PurchaseForm
              handleChange={handleChange}
              handleSubmit={handleSubmit}
              attributes={order.data.order}
            />
          </Column>
        </Fragment>
      }
    </Wrapper>
  )
}

export default Order
