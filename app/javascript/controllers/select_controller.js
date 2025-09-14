// app/javascript/controllers/select_controller.js

import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"
import TomSelect from "tom-select"

export default class extends Controller {
  static values = {
    url: String,
    valueField: {type: String, default: "value"},
    labelField: {type: String, default: "label"},
    submitOnChange: false
  }
  
  static targets = ["participant", "room"]

  connect() {
    let options = {}

    if (this.hasUrlValue) {
      options.valueField = this.valueFieldValue
      options.labelField = this.labelFieldValue
      options.searchField = this.labelFieldValue
      options.load = this.load.bind(this)
    }

    if (this.submitOnChangeValue)
      options.onChange = this.submitOnChange.bind(this)

    // Check if the element has the 'data-controller' attribute
    if (this.element.dataset.controller === "select") {
      this.select = new TomSelect(this.element, options)
    }
  }

  disconnect() {
    if (this.select) {
      this.select.destroy()
    }
  }
  
  // New method to handle room filtering based on participant type
  filterRooms(event) {
    const participantId = event.target.value
    const roomSelect = document.getElementById("room-select")
    
    // Clear and disable the room dropdown
    const roomTomSelect = roomSelect.tomselect
    if (roomTomSelect) {
      roomTomSelect.clear(true)
      roomTomSelect.disable()
    }

    if (participantId) {
      // Fetch rooms based on participant type
      get(`/room_assignments/rooms_by_participant_type?participant_id=${participantId}`, {
        responseKind: "json"
      })
      .then(response => response.json)
      .then(rooms => {
        // Clear old options
        if (roomTomSelect) {
          roomTomSelect.clearOptions()
          
          if (rooms.length > 0) {
            rooms.forEach(room => {
              roomTomSelect.addOption({value: room.id, text: `${room.hotel_name} - ${room.room_name}`})
            })
          } else {
            roomTomSelect.addOption({value: "", text: "No available rooms for this participant type"})
          }
          
          roomTomSelect.enable()
        }
      })
      .catch(error => {
        console.error("Error fetching rooms:", error)
        if (roomTomSelect) {
          roomTomSelect.addOption({value: "", text: "Error fetching rooms. Please check the console."})
          roomTomSelect.enable()
        }
      })
    } else {
      // If no participant is selected, re-enable the room dropdown and clear options
      if (roomTomSelect) {
        roomTomSelect.clearOptions()
        roomTomSelect.enable()
      }
    }
  }

  async load(query, callback) {
    const response = await get(`${this.urlValue}?query=${query}`)
    if (response.ok) {
      const json = await response.json
      callback(json)
    } else {
      callback()
    }
  }

  submitOnChange(value) {
    if (value) {
      this.element.form.requestSubmit()
      this.select.clear(true) // resets silently
    }
  }
}