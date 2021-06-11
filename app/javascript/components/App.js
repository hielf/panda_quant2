import React from 'react'
import { Route, Switch } from 'react-router-dom'
import Package from './Package/Package'
import Order from './Order/Order'

const App = () => {
  return (
    <Switch>
      <Route exact path="/order/:id" component={Order}/>
      <Route exact path="/package/:id" component={Package}/>
    </Switch>
  )
}

export default App
