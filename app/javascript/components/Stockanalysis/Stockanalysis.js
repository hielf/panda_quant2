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
  const [quotation, setQuotation] = useState({})
  const [loaded, setLoaded] = useState(false)

  useEffect(() => {
    const url = '/api/stock_lists/stock_analysis_results'

    axios.get(url, { params: { id: '300' } })
    .then( resp => {
      setStockanalysis(resp.data)
      const stock_code = resp.data.data.stock_code
      const duration = resp.data.data.duration
      const start_time = resp.data.data.begin_time
      const length = 20

      axios.get('/api/stock_lists/market_quotations', {
        params: {
          "stock_code": stock_code,
          "duration": duration,
          "start_time": start_time,
          "length": length,
        }
      })
      .then(resp => {
        setQuotation(resp.data)
        setLoaded(true)
      })
      .catch(function (error) {
        console.log(error)
      })
    } )
    .catch( resp => console.log(resp) )
  }, [])

  if (loaded) {
    // debugger
    const chart = createChart(document.getElementById('chart'), {
      width: 600,
      height: 300,
    	timeScale: {
    			timeVisible: true,
          borderColor: '#D1D4DC',
    		},
      rightPriceScale: {
      	borderColor: '#D1D4DC',
      },
       layout: {
        backgroundColor: '#ffffff',
        textColor: '#000',
      },
      grid: {
        horzLines: {
          color: '#F0F3FA',
        },
        vertLines: {
          color: '#F0F3FA',
        },
      },
    })
    const series = chart.addCandlestickSeries({
  		upColor: 'rgb(38,166,154)',
  		downColor: 'rgb(255,82,82)',
  		wickUpColor: 'rgb(38,166,154)',
  		wickDownColor: 'rgb(255,82,82)',
  		borderVisible: false,
    })

    console.log(quotation.data)

    const data = quotation.data
    series.setData(data)

    const markers = []
    markers.push({ time: data[data.length - 1].time, position: 'aboveBar', color: '#e91e63', shape: 'arrowDown', text: '卖出 @ ' + Math.floor(data[data.length - 1].high + 6) })
    markers.push({ time: data[data.length - 2].time, position: 'belowBar', color: '#2196F3', shape: 'arrowUp', text: '买入 @ ' + Math.floor(data[data.length - 2].low - 6) })
    markers.push({ time: data[data.length - 3].time, position: 'aboveBar', color: '#f68410', shape: 'circle', text: 'D' })
    series.setMarkers(markers)
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
