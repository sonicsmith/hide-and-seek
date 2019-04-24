import React, { Component } from "react"
import Card, {
  CardPrimaryContent,
  CardActions,
  CardActionButtons
} from "@material/react-card"
import Button from "@material/react-button"
import "@material/react-card/dist/card.css"
import "@material/react-button/dist/button.css"
import "./RoomSelector.css"

class Room extends Component {
  render() {
    const { id, selected, taken } = this.props
    let backgroundColor
    if (taken) {
      backgroundColor = "rgba(255,0,0,0.2)"
    } else {
      backgroundColor = selected ? "rgba(100,100,100,0.3)" : "#bcc7d8"
    }

    return (
      <div
        className="room"
        style={{ backgroundColor }}
        onClick={() => {
          if (!taken) {
            this.props.onClick(id)
          }
        }}
      >
        <p className="roomName">{taken ? "TAKEN" : id}</p>
      </div>
    )
  }
}

class RoomSelector extends Component {
  render() {
    const rooms = ["1", "2", "3", "4", "5", "6"]
    const { emptyRooms, selectedRoom, onSelect } = this.props
    return (
      <Card style={{ margin: 32, padding: 32 }}>
        <CardPrimaryContent>
          <div id="house">
            {rooms.map(id => (
              <Room
                id={id}
                key={id}
                selected={id === selectedRoom}
                taken={!emptyRooms.includes(id)}
                onClick={onSelect}
              />
            ))}
          </div>
        </CardPrimaryContent>
        <CardActions>
          <CardActionButtons>
            <Button>HIDE</Button>
          </CardActionButtons>
        </CardActions>
      </Card>
    )
  }
}

export default RoomSelector
