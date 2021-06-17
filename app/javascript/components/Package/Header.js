import React from 'react'
import styled from 'styled-components'

const Wrapper = styled.div`
  font-size: 24px;
  font-weight: 700;
  font-family: MicrosoftYaHei;
  margin-bottom: 25px;
  color: #fec107;
  text-align: center;
`
const Title = styled.h1`
  font-size: 28px;
  padding: 10px 0;
`

const Packagetype = styled.div`
  color: #757575;
  font-size: 18px;
  padding: 10px 0;
`

const Watchnum = styled.div`
  font-size: 18px;
  font-weight: bold;
  padding: 10px 0;
`

const Marketprice = styled.div`
  color: #6d757a;
  font-size: 18px;
  font-weight: light;
  padding: 10px 0;
  text-decoration: line-through;
`

const Realprice = styled.div`
  font-size: 24px;
  font-weight: light;
  color: #fec107;
  padding: 10px 0;
`

const Desc = styled.div`
  font-size: 12px;
  font-weight: light;
  padding: 10px 0;
`

const Header = (props) => {
  const {market_price, package_type, period, real_price, title, discount, desc, watch_num} = props.attributes

  return (
    <Wrapper>
      <Title>{title}</Title>
      <div>
        <Desc>{desc}</Desc>
        <Realprice>¥ {real_price}</Realprice>
        <Marketprice>¥ {market_price}</Marketprice>
      </div>
    </Wrapper>
  )
}

export default Header
