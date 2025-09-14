class AddStatusAndParticipantToRooms < ActiveRecord::Migration[7.1]
  def change
    # Adds the status column with a default value of 0 (for `available`)
    add_column :rooms, :status, :integer, default: 0
    
    # Adds the participant_id column, which can be null
    add_reference :rooms, :participant, foreign_key: true, null: true
  end
end