import React, { Component } from "react"
import HideAndSeekContract from "./contracts/HideAndSeek.json"
import getWeb3 from "./utils/getWeb3"
import SeekPriceChart from "./components/SeekPriceChart"

import "./App.css"
import RoomSelector from "./components/RoomSelector.jsx"

class App extends Component {
  state = { seekPrice: null, web3: null, accounts: null, contract: null }

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3()
      console.log("got web3", web3)
      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts()
      console.log("got accounts", accounts)
      // Get the contract instance.
      const networkId = await web3.eth.net.getId()
      console.log("got networkId", networkId)
      const deployedNetwork = HideAndSeekContract.networks[networkId]
      const instance = new web3.eth.Contract(
        HideAndSeekContract.abi,
        deployedNetwork && deployedNetwork.address
      )

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance }, this.refresh)
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`
      )
      console.error(error)
    }
  }

  refresh = async () => {
    const { contract } = this.state
    const seekPrice = await contract.methods.getSeekTokenPrice().call()
    console.log("Price Refresh", seekPrice)
    this.setState({ seekPrice })
  }

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>
    }
    return (
      <div>
        <SeekPriceChart price={this.state.seekPrice} />
        <RoomSelector />
      </div>
    )
  }
}

export default App
