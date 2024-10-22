import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug    = false
window.Stimulus      = application
export { application }
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