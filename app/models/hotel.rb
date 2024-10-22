class Hotel < ApplicationRecord
  broadcasts_refreshes
  has_many :rooms
end
