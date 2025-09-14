class CreateHotelParticipantTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :hotel_participant_types do |t|
      t.references :hotel, null: false, foreign_key: true
      t.references :participant_type, null: false, foreign_key: true

      t.timestamps
    end
    add_index :hotel_participant_types, [:hotel_id, :participant_type_id], unique: true
  end
end