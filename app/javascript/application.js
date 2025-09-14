/* eslint no-console:0 */

import "@hotwired/turbo-rails"
require("@rails/activestorage").start()
require("local-time").start()

import "./channels"
import "./controllers"
import "./src/**/*"
import "@hotwired/turbo-rails" 
import './custom_ujs';
import "select2"
import "select2/dist/css/select2.css"

// import Rails from '@rails/ujs';
// Rails.start();
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
