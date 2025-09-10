json.extract! side_event, :id, :event_name, :description, :startdate, :enddate, :venue, :created_at, :updated_at
json.url side_event_url(side_event, format: :json)
