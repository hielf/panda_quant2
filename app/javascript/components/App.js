import React from 'react'
import { Route, Switch } from 'react-router-dom'
import Package from './Package/Package'
import Subscribtion from './Subscribtion/Subscribtion'
import Stockanalysis from './Stockanalysis/Stockanalysis'

const App = () => {
  return (
    <Switch>
      <Route exact path="/package/:id" component={Package}/>
      <Route exact path="/subscribtion/:id" component={Subscribtion}/>
      <Route exact path="/stockanalysis/:id" component={Stockanalysis}/>
    </Switch>
  )
}

export default App
