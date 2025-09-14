# app/models/room_assignment.rb

class RoomAssignment < ApplicationRecord
  broadcasts_refreshes
  belongs_to :participant
  belongs_to :room

  validates :arrived_date, presence: true
  validates :checkin_date, presence: true
  validates :checkout_date, presence: true

  # Use a Rails enum for status.
  enum status: { assigned: 0, unassigned: 1, deleted: 2 }

  # A participant can only have one room assignment.
  validates :participant_id, uniqueness: { message: "is already assigned to a room" }

  # A room can only have ONE assigned RoomAssignment record.
  validates :room_id, uniqueness: { conditions: -> { assigned }, message: "is already assigned to another participant" }
  
  # Method to get the participant's name
  def participant_name
    participant&.name
  end

  # Method to get the room number
  def room_name
    room&.room_number
  end

  # Method to get the hotel name
  def hotel_name
    room&.hotel&.name
  end
end