class HotelParticipantType < ApplicationRecord
  belongs_to :hotel
  belongs_to :participant_type
end
