import React from 'react'
import { Route, Switch } from 'react-router-dom'
import Package from './Package/Package'
import Subscribtion from './Subscribtion/Subscribtion'

const App = () => {
  return (
    <Switch>
      <Route exact path="/package/:id" component={Package}/>
      <Route exact path="/subscribtion/:id" component={Subscribtion}/>
    </Switch>
  )
}

export default App
