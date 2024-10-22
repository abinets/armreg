class AddAttendanceFieldsToParticipants < ActiveRecord::Migration[7.2]
  def change
    add_column :participants, :attended_day_0, :boolean
    add_column :participants, :attended_day_1, :boolean
    add_column :participants, :attended_day_2, :boolean
    add_column :participants, :attended_day_3, :boolean
  end
end
