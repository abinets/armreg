class CreateHotelAssignmentPolicies < ActiveRecord::Migration[7.2]
  def change
    create_table :hotel_assignment_policies do |t|
      t.references :hotel, null: false, foreign_key: true
      t.references :participant_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
