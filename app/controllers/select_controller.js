// app/javascript/controllers/select_controller.js

import { Controller } from "@hotwired/stimulus"
import $ from 'jquery'

// Stimulus controller for searchable select dropdowns and dynamic filtering
export default class extends Controller {
  static targets = ["participant", "room"]

  connect() {
    // Initialize Select2 on the participant select box
    $(this.participantTarget).select2()
    
    // Initialize Select2 on the room select box
    $(this.roomTarget).select2({
      placeholder: "Search for a Room",
      allowClear: true
    })

    // Store the original options of the room select box
    this.originalRoomOptions = $(this.roomTarget).html()
  }

  // Action to filter rooms when the participant changes
  filterRooms(event) {
    const participantId = event.target.value
    const roomSelect = $(this.roomTarget)
    
    // Disable the room select box while fetching
    roomSelect.select2('destroy')
    roomSelect.prop('disabled', true).empty()

    if (participantId) {
      // Fetch the rooms from the server based on the participant type
      fetch(`/room_assignments/rooms_by_participant_type?participant_id=${participantId}`, {
        headers: { 'Accept': 'application/json' }
      })
      .then(response => response.json())
      .then(data => {
        let options = '<option value="">Select a Room</option>'
        data.forEach(room => {
          options += `<option value="${room.id}">${room.hotel_name} - ${room.room_name}</option>`
        })
        roomSelect.html(options)
      })
      .catch(error => {
        console.error("Error fetching rooms:", error)
        roomSelect.html('<option value="">Error fetching rooms</option>')
      })
      .finally(() => {
        // Re-enable and re-initialize the room select box
        roomSelect.prop('disabled', false)
        $(this.roomTarget).select2({
          placeholder: "Search for a Room",
          allowClear: true
        })
      })
    } else {
      // If no participant is selected, restore the original room options
      roomSelect.html(this.originalRoomOptions)
      roomSelect.prop('disabled', false)
      $(this.roomTarget).select2({
        placeholder: "Search for a Room",
        allowClear: true
      })
    }
  }

  // Disconnect Select2 when the controller is removed from the DOM
  disconnect() {
    $(this.participantTarget).select2('destroy')
    $(this.roomTarget).select2('destroy')
  }
}