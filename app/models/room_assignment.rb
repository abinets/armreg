class RoomAssignment < ApplicationRecord
  broadcasts_refreshes
  belongs_to :participant
  belongs_to :room

validates :arrived_date, presence: true
validates :checkin_date, presence: true
validates :checkout_date, presence: true


  # Status constants
  STATUS_ASSIGNED = 1
  STATUS_UNASSIGNED = 0


def participant_name
  participant&.name
end

def room_name
  room&.room_number
end

def hotel_name
  room&.hotel&.name
end

  def change_status(new_status)
    update(status: new_status)
  end

  
end