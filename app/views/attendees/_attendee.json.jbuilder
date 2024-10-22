json.extract! attendee, :id, :full_name, :address, :org, :days_to_attend, :created_at, :updated_at
json.url attendee_url(attendee, format: :json)
