class ParticipantType < ApplicationRecord
  broadcasts_refreshes
  has_many :participants
  has_many :hotel_assignment_policies
  has_many :hotels, through: :hotel_assignment_policies

  has_many :hotel_participant_types, dependent: :destroy
  has_many :hotels, through: :hotel_participant_types
end