import React from 'react'
import axios from 'axios'
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

const PurchaseForm = (props) => {

  return (
    <div className="wrapper">
      <form>
        <div>购买</div>
      </form>
    </div>
  )
}

export default PurchaseForm
