import React, { useState, useEffect } from 'react'
import axios from 'axios'
const Package = (props) => {
  const [packages, setPackages] = useState([])

  useEffect(() => {
    axios.get('/api/packages/1')
    .then( resp => console.log(resp) )
    .catch( resp => console.log(resp) )
  }, [packages.length])

  return (
    <div>Package#show</div>
  )
}

export default Package
