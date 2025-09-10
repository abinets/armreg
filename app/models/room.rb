class Room < ApplicationRecord
  broadcasts_refreshes
  belongs_to :hotel
  has_many :room_assignments

  validates :room_number, presence: true
  validates :room_type, presence: true
  validates :floor, presence: true

  # Method to get the hotel name
  def hotel_name
    hotel&.name
  end
end