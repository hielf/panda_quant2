import React, { useState, useEffect, Fragment } from 'react'
import styled from 'styled-components'

const Wrapper = styled.div`
  background: #fec107;
  margin: 5px 5px;
  padding: 1px;
  text-align: center;
`

const Column = styled.div`
  background: #fff;
  /* line-height: 95vh; */
`

const Main = styled.div`
  display: table;
  padding: 0;
  height: 95vh;  
  /* height: 50vh; */
`

const Message = styled.span`
  color: #fec107;
  font-size: 20px;
  font-weight: light;
  font-family: MicrosoftYaHei;
  display: table-cell;
  vertical-align: middle;
`

const Subscribtion = (props) => {
  const [subscribtion, setSubscribtion] = useState({})
  const [successed, setSuccessed] = useState(false)

  const handleChange = (e) => {
    e.preventDefault()
  }

  const handleSubmit = (e) => {
    e.preventDefault()

  }

  return (
    <Wrapper>
      <Fragment>
        <Column>
          <Main>
            <Message>套餐购买成功，请在公众号内回复"3"，设置您的订阅</Message>
          </Main>
        </Column>
      </Fragment>
    </Wrapper>
  )
}

export default Subscribtion
