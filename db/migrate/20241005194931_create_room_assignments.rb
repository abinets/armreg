class CreateRoomAssignments < ActiveRecord::Migration[7.2]
  def change
    create_table :room_assignments do |t|
      t.references :participant, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.date :arrived_date
      t.date :checkin_date
      t.date :checkout_date
      t.text :notes

      t.timestamps
    end
  end
end
