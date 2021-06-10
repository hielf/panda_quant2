import React, {Fragment} from 'react'
import axios from 'axios'
import styled from 'styled-components'

const Wrapper = styled.div`
  background: #fff;
  padding: 20px;
  height: 100vh;
  padding-top: 100px;
`

const SubmitBtn = styled.button`
  color: #fff;
  background: #333;
  padding: 12px;
  font-size: 18px;
  cursor: pointer;
  transition: ease-in-out 0.1s;
  border: 1px solid #fff;
  width: 100%;
  margin-top: 20px;

  &:hover {
    background: #fff;
    color: #333;
    border: 1px solid #fff;
  }
`

const PurchaseForm = (props) => {

  return (
    <div className="wrapper">
      <form onSubmit={props.handleSubmit}>
        <SubmitBtn type="submit">购买</SubmitBtn>
      </form>
    </div>
  )
}

export default PurchaseForm
