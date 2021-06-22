import React, { useState, useEffect, Fragment } from 'react'
import axios from 'axios'
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

const Subscribtion = (props) => {
  const [order, setOrder] = useState({})
  const [loaded, setLoaded] = useState(false)

  const handleChange = (e) => {
    e.preventDefault()
  }

  const handleSubmit = (e) => {
    e.preventDefault()

  }

  return (
    <Wrapper>

    </Wrapper>
  )
}

export default Subscribtion
