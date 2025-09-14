# app/models/room.rb

class Room < ApplicationRecord
  broadcasts_refreshes

  # Associations
  belongs_to :hotel
  belongs_to :participant, optional: true
  has_many :room_assignments, dependent: :destroy

  # This association is crucial for finding the assigned participant
  has_one :assigned_participant, -> { where(status: :assigned) }, class_name: 'RoomAssignment'
  
  # A simpler way to get all participants for a room
  has_many :participants, through: :room_assignments

  # Enums
  enum status: { available: 0, assigned: 1 }

  # Validations
  validates :room_number, presence: true, uniqueness: { scope: :hotel_id }
  validates :room_type, presence: true
  validates :floor, presence: true
  validates :status, presence: true
  
  # The new validation to prevent assigning an already assigned room
  validate :room_is_available_for_assignment, on: :create
  
  def room_is_available_for_assignment
    if self.status_changed? && self.assigned? && Room.assigned.exists?(self.id)
      errors.add(:base, "Room is already assigned to another participant")
    end
  end

  # Method to get the hotel name
  def hotel_name
    hotel&.name
  end

  def full_room_name
    "#{hotel_name}/#{room_number}"
  end
  

    def assigned_participant_info
    # Corrected method to be more direct and reliable
    participant = self.participant
    
    if participant.present?
      participant_name = participant.name.presence || 'Name Missing'
      organization_name = participant.organization&.name.presence || 'Organization Missing'
      "#{participant_name} (#{organization_name})"
    else
      # This message will show up if the participant record is missing
      "Participant Missing"
    end
  end


end