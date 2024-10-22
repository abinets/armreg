json.extract! field_visit_activity, :id, :name, :description, :field_visit_area_id, :scheduled_date, :duration, :max_participants, :notes, :created_at, :updated_at
json.url field_visit_activity_url(field_visit_activity, format: :json)
