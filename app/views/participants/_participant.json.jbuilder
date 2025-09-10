json.extract! participant, :id, :name, :organization_id, :registration_date, :location, :position, :email, :telephone_number, :participant_type_id, :group_id, :emergency_contact_name, :emergency_contact_number, :side_event_id, :meal_options, :resourceMaterial_take, :accommodation_required, :notes, :created_at, :updated_at
json.url participant_url(participant, format: :json)
