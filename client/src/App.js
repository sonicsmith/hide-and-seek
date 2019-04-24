import React, { Component } from "react"
import HideAndSeekContract from "./contracts/HideAndSeek.json"
import getWeb3 from "./utils/getWeb3"
import SeekPriceChart from "./components/SeekPriceChart"
import RoomSelector from "./components/RoomSelector.jsx"

const HIDE_PAGE = 0
const SEEK_PAGE = 1

class App extends Component {
  state = {
    seekPrice: null,
    emptyRooms: [],
    selectedRoom: null,
    web3: null,
    accounts: null,
    contract: null,
    currentPage: HIDE_PAGE
  }

  componentDidMount = async () => {
    this.connectToWeb3()
  }

  connectToWeb3 = async () => {
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
    const emptyRooms = await contract.methods.getEmptyRoomIds().call()
    console.log("seekPrice", seekPrice)
    console.log("emptyRooms", emptyRooms)
    this.setState({ seekPrice, emptyRooms })
  }

  hideInRoom = () => {
    console.log("Hiding in room", this.state.selectedRoom)
  }

  render() {
    const { emptyRooms, seekPrice, selectedRoom, currentPage } = this.state
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>
    }
    if (currentPage === HIDE_PAGE) {
      return (
        <div>
          <RoomSelector
            emptyRooms={emptyRooms}
            selectedRoom={selectedRoom}
            onSelect={id => {
              if (id === selectedRoom) {
                this.setState({ selectedRoom: null })
              } else {
                this.setState({ selectedRoom: id })
              }
            }}
          />
        </div>
      )
    } else {
      return (
        <div>
          <h1>Landing page</h1>
          This should be where the user comes first
        </div>
      )
      //
    }
  }
}

export default App
