import React, { useState, useEffect, Fragment } from 'react'
import axios from 'axios'
import { createChart } from 'lightweight-charts';
import styled from 'styled-components'
// import Chart from './Chart'

const Wrapper = styled.div`
  background: #fec107;
  margin: 5px 5px;
  padding: 1px;
  text-align: center;
`

const Column = styled.div`
  background: #fff;
`

const Main = styled.div`
  display: table;
  padding: 0;
  height: 95vh;
  width: 100%;
  font-family: MicrosoftYaHei;
  /* height: 50vh; */
`

const Title = styled.div`
  color: #ffd658;
  font-size: 24px;
  font-weight: light;
  /* display: table-cell; */
  vertical-align: middle;
  padding: 20vh 0;
`

const Message = styled.span`
  color: #fec107;
  font-size: 20px;
  font-weight: light;
  /* display: table-cell; */
  vertical-align: middle;
  padding: 10px 0;
`


const Stockanalysis = (props) => {
  const [stockanalysis, setStockanalysis] = useState({})
  const [loaded, setLoaded] = useState(false)

  useEffect(() => {
    const url = '/api/packages/' + '10'

    axios.get(url)
    .then( resp => {
      setLoaded(true)
    } )
    .catch( resp => console.log(resp) )
  }, [])

  if (loaded) {
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
  }

  return (
    <Wrapper>
      <Fragment>
        <Column>
          <Main>
            <div id="chart"
            />
          </Main>
        </Column>
      </Fragment>
    </Wrapper>
  )
}

export default Stockanalysis
