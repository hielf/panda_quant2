import React, {Fragment} from 'react'
import axios from 'axios'
import styled from 'styled-components'

const Wrapper = styled.div`
  background: #fff;
  width: 100%;
  padding: 20px 0 20px 0;
  text-align: center;

  &:last-child {
    margin-bottom: 0;
  }
`

const SubmitBtn = styled.button`
  color: #fff;
  background: #fec107;
  padding: 8px 10px;
  font-size: 18px;
  cursor: pointer;
  transition: ease-in-out 0.1s;
  border: 0;
  border-radius: 3px;
  outline: none;
  width: 80%;
  margin-top: 20px;

  &:hover {
    background: #ffd658;
  }
`

const PurchaseForm = (props) => {

  return (
    <Wrapper>
      <form onSubmit={props.handleSubmit}>
        <SubmitBtn>购买</SubmitBtn>
      </form>
    </Wrapper>
  )
}

export default PurchaseForm
