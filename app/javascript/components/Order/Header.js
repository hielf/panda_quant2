import React from 'react'
import styled from 'styled-components'

const Wrapper = styled.div`
  padding: 50px 100px 50px 0;
  font-size: 30px;

  img {
    height: 60px;
    width: 60px;
    border-radius: 100%;
    border: 1px solid rgba(0,0,0,0.1);
    margin-bottom: -8px;
  }
`

const Packagetype = styled.div`
  font-size: 18px;
  padding: 10px 0;
`

const Watchnum = styled.div`
  font-size: 18px;
  font-weight: bold;
  padding: 10px 0;
`

const Marketprice = styled.div`
  font-size: 18px;
  font-weight: bold;
  padding: 10px 0;
`

const Realprice = styled.div`
  font-size: 18px;
  font-weight: bold;
  padding: 10px 0;
`

const Desc = styled.div`
  font-size: 10px;
  font-weight: light;
  padding: 10px 0;
`

const Header = (props) => {
  const {market_price, package_type, period, real_price, title, discount, desc, watch_num} = props.attributes

  return (
    <Wrapper>
      <h1>{title}</h1>
      <div>
        <Packagetype>({package_type})</Packagetype>
        <Marketprice>市价：{market_price} 元</Marketprice>
        <Realprice>现价：{real_price} 元</Realprice>
        <Desc>{desc}</Desc>
      </div>
    </Wrapper>
  )
}

export default Header
