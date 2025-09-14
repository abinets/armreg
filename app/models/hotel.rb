class Hotel < ApplicationRecord
  broadcasts_refreshes
  has_many :rooms
  has_many :hotel_assignment_policies
  has_many :participant_types, through: :hotel_assignment_policies

  has_many :hotel_participant_types, dependent: :destroy
  has_many :participant_types, through: :hotel_participant_types

end