import React, { useState, useEffect, Fragment } from 'react'
import axios from 'axios'
// import Header from './Header'
import { createChart } from 'lightweight-charts';
import styled from 'styled-components'
import dateFormat from 'dateformat'
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
  padding: 0;
  height: 95vh;
  width: 100%;
  text-align: center;
  font-family: MicrosoftYaHei;
  /* height: 50vh; */
`

const Title = styled.div`
  color: #666c72;
  font-size: 24px;
  font-weight: light;
  /* display: table-cell; */
  vertical-align: middle;
  padding: 2vh 0;
`

const Subtitle = styled.div`
  color: #666c72;
  font-size: 14px;
  font-weight: light;
  /* display: table-cell; */
  vertical-align: middle;
  padding: 0;
`

const Info = styled.div`
  /* float: left; */
  width: 100%;
  color: #666c72;
  font-size: 16px;
  font-weight: light;
  /* display: table-cell; */
  vertical-align: middle;
  padding: 0 0;
`

const Detail = styled.div`
  width: 100%;
  font-size: 24px;
  font-weight: light;
  text-align: left;
  padding: 2vh 0;
`

const Desc = styled.p`
  color: #666c72;
  text-align: left;
  padding-left: 8px;
  margin: 5px 0px;
`

const Hint = styled.p`
  color: #fec107;
  text-align: center;
  padding-left: 8px;
  margin: 20px 0px;
  font-size: 20px;
`


const Stockanalysis = (props) => {
  const [stockanalysis, setStockanalysis] = useState({})
  const [quotation, setQuotation] = useState({})
  const [loaded, setLoaded] = useState(false)

  useEffect(() => {
    const id = props.match.params.id
    const url = '/api/stock_lists/stock_analysis_results'

    axios.get(url, { params: { id: id } })
    .then( resp => {
      setStockanalysis(resp.data)
      var stock_code = resp.data.data.stock_code
      var duration = resp.data.data.duration
      var start_time = resp.data.data.begin_time
      var end_time = resp.data.data.end_time
      var length = 20
      if (duration == '1d') {
        length = 2 + (Math.abs(Date.parse(end_time) - Date.parse(start_time)) / (1000 * 60 * 60 * 24))
      }
      else {
        length = 7 + (Math.abs(Date.parse(end_time) - Date.parse(start_time)) / (1000 * 60))
      }
      console.log(length)


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
    .catch(function (error) {
      console.log(error)
    })
  }, [])

  if (loaded) {
    // debugger
    const canvas = document.getElementById('chart')
    const chart = createChart(canvas, {
      width: canvas.offsetWidth,
      height: 300,
    	timeScale: {
    			timeVisible: true,
          borderColor: '#D1D4DC',
    		},
      rightPriceScale: {
      	borderColor: '#D1D4DC',
        scaleMargins: {
    			top: 0.1,
    			bottom: 0.1,
    		},
      },
      watermark: {
    		visible: true,
    		fontSize: 24,
    		horzAlign: 'right',
    		vertAlign: 'bottom',
    		color: 'rgba(117, 117, 117, 0.3)',
    		text: 'WX: 熊猫宽客',
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

    chart.timeScale().fitContent()

    const series = chart.addCandlestickSeries({
  		upColor: 'rgb(255,82,82)',
  		downColor: 'rgb(38,166,154)',
  		wickUpColor: 'rgb(255,82,82)',
  		wickDownColor: 'rgb(38,166,154)',
  		borderVisible: false,
    })

    console.log(quotation.data)
    console.log(stockanalysis.data)
    // debugger

    const data = quotation.data
    series.setData(data)

    const markers = []
    if (stockanalysis.data.duration == '1d') {
      markers.push({ time: JSON.parse(stockanalysis.data.results)[0][3], position: 'belowBar', color: '#2196F3', shape: 'arrowUp', text: JSON.parse(stockanalysis.data.results)[0][2] + ' @ ' + JSON.parse(stockanalysis.data.results)[0][1] })
      markers.push({ time: JSON.parse(stockanalysis.data.results)[1][3], position: 'aboveBar', color: '#f55607', shape: 'circle', text: JSON.parse(stockanalysis.data.results)[1][2] })
      markers.push({ time: JSON.parse(stockanalysis.data.results)[2][3], position: 'belowBar', color: '#f55607', shape: 'circle', text: JSON.parse(stockanalysis.data.results)[2][2] })
      markers.push({ time: JSON.parse(stockanalysis.data.results)[3][3], position: 'aboveBar', color: '#e91e63', shape: 'arrowDown', text: JSON.parse(stockanalysis.data.results)[3][2] })
    }
    else {
      markers.push({ time: Date.parse(JSON.parse(stockanalysis.data.results)[0][3])/1000 + (60 * 60 * 8), position: 'belowBar', color: '#2196F3', shape: 'arrowUp', text: JSON.parse(stockanalysis.data.results)[0][2] + ' @ ' + JSON.parse(stockanalysis.data.results)[0][1] })
      markers.push({ time: Date.parse(JSON.parse(stockanalysis.data.results)[1][3])/1000 + (60 * 60 * 8), position: 'aboveBar', color: '#f55607', shape: 'circle', text: JSON.parse(stockanalysis.data.results)[1][2] })
      markers.push({ time: Date.parse(JSON.parse(stockanalysis.data.results)[2][3])/1000 + (60 * 60 * 8), position: 'belowBar', color: '#f55607', shape: 'circle', text: JSON.parse(stockanalysis.data.results)[2][2] })
      markers.push({ time: Date.parse(JSON.parse(stockanalysis.data.results)[3][3])/1000 + (60 * 60 * 8), position: 'aboveBar', color: '#e91e63', shape: 'arrowDown', text: JSON.parse(stockanalysis.data.results)[3][2] })
      // markers.push({ time: Date.parse(JSON.parse(stockanalysis.data.results)[3][3])/1000 + (60 * 60 * 8), position: 'aboveBar', color: '#e91e63', shape: 'arrowDown', text: JSON.parse(stockanalysis.data.results)[3][2] + ' @ ' + JSON.parse(stockanalysis.data.results)[3][1] })
    }

    series.setMarkers(markers)
  }

  return (
    <Wrapper>
      <Fragment>
        <Column>
          { loaded && <Title> {stockanalysis.data.stock_display_name} </Title> }
          { loaded && <Subtitle> {dateFormat(stockanalysis.data.end_time, "yyyy/mm/dd")} </Subtitle> }
          <Main>
            <Detail id="chart"></Detail>
            {
              loaded &&
              <Info>
                <Desc>起始时间： {JSON.parse(stockanalysis.data.results)[0][3]}</Desc>
                <Desc>{JSON.parse(stockanalysis.data.results)[0][2]}： {JSON.parse(stockanalysis.data.results)[0][1]}</Desc>
                <Desc>{JSON.parse(stockanalysis.data.results)[1][2]}： {JSON.parse(stockanalysis.data.results)[1][1]}</Desc>
                <Desc>{JSON.parse(stockanalysis.data.results)[2][2]}： {JSON.parse(stockanalysis.data.results)[2][1]}</Desc>
                <Desc>{JSON.parse(stockanalysis.data.results)[3][2]}： {JSON.parse(stockanalysis.data.results)[3][1]}</Desc>
                <Desc>结束时间： {JSON.parse(stockanalysis.data.results)[3][3]}</Desc>
                <Hint>已识别到W形态</Hint>
              </Info>
            }
          </Main>
        </Column>
      </Fragment>
    </Wrapper>
  )
}

export default Stockanalysis
