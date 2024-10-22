json.extract! hotel, :id, :name, :location, :room_numbers, :created_at, :updated_at
json.url hotel_url(hotel, format: :json)
