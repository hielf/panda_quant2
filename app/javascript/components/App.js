import React from 'react'
import { Route, Switch } from 'react-router-dom'
import Package from './Package/Package'

const App = () => {
  return (
    <Switch>
      <Route exact path="/package/:id" component={Package}/>
    </Switch>
  )
}

export default App
