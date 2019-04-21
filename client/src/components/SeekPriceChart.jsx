import React, { Component } from "react"

class SeekPriceChart extends Component {
  render() {
    const { price } = this.props
    return (
      <div>
        <p>Price Of SEEK: {price} ETH</p>
      </div>
    )
  }
}

export default SeekPriceChart
