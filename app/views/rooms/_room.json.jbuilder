json.extract! room, :id, :room_number, :room_type, :floor, :hotel_id, :created_at, :updated_at
json.url room_url(room, format: :json)
