class AddFieldVisitActivityToParticipants < ActiveRecord::Migration[7.2]
  def change
    add_column :participants, :field_visit_activity_id, :integer
  end
end
