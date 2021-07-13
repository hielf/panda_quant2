import React, { Component } from 'react'
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
  font-size: 30px;
  color: #ffd658;
  padding: 10px 0;
`

const Chart = (props) => {
  const chart = createChart(document.getElementById('chart'), { width: 400, height: 300 })
  const lineSeries = chart.addLineSeries()

  lineSeries.setData([
    { time: '2019-04-11', value: 80.01 },
    { time: '2019-04-12', value: 96.63 },
    { time: '2019-04-13', value: 76.64 },
    { time: '2019-04-14', value: 81.89 },
    { time: '2019-04-15', value: 74.43 },
    { time: '2019-04-16', value: 80.01 },
    { time: '2019-04-17', value: 96.63 },
    { time: '2019-04-18', value: 76.64 },
    { time: '2019-04-19', value: 81.89 },
    { time: '2019-04-20', value: 74.43 },
  ])

  return (
    <Wrapper>
      
    </Wrapper>
  )
}

export default Chart
