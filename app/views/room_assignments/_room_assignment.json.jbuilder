json.extract! room_assignment, :id, :participant_id, :room_id, :arrived_date, :checkin_date, :checkout_date, :notes, :created_at, :updated_at
json.url room_assignment_url(room_assignment, format: :json)
