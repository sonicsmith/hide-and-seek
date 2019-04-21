import React, { Component } from "react"
import "./RoomSelector.css"

class Room extends Component {
  render() {
    const backgroundColor = this.props.selected ? "#DDD" : "transparent"
    return (
      <div
        className="room"
        style={{ backgroundColor }}
        onClick={() => {
          this.props.onClick(this.props.id)
        }}
      >
        <p className="roomName">{this.props.id}</p>
      </div>
    )
  }
}

class RoomSelector extends Component {
  constructor() {
    super()
    this.state = { selectedRoom: "" }
  }
  render() {
    const rooms = ["1", "2", "3", "4", "5", "6", "7", "8"]
    const { selectedRoom } = this.state
    return (
      <div id="plan">
        <div className="start" />
        {rooms.map(id => (
          <Room
            id={id}
            key={id}
            selected={id === selectedRoom}
            onClick={selectedId => {
              this.setState({ selectedRoom: selectedId })
            }}
          />
        ))}
      </div>
    )
  }
}

export default RoomSelector
