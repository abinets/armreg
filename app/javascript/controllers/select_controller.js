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

    this.select = new TomSelect(this.element, options)
  }

  disconnect() {
    this.select.destroy()
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
document.addEventListener("DOMContentLoaded", () => {
  const hotelSelect = document.getElementById("hotel_select");
  const roomSelect = document.getElementById("room_select");

  hotelSelect.addEventListener("change", function() {
    const hotelId = this.value;

    // Clear the room dropdown
    roomSelect.innerHTML = '';

    if (hotelId) {
      fetch(`/room_assignments/rooms_by_hotel?hotel_id=${hotelId}`)
        .then(response => response.json())
        .then(data => {
          data.forEach(room => {
            const option = document.createElement("option");
            option.value = room.id;
            option.textContent = room.room_number; // Adjust this based on your room attribute
            roomSelect.appendChild(option);
          });
        });
    }
  });
});