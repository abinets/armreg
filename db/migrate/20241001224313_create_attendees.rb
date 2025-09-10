class CreateAttendees < ActiveRecord::Migration[7.2]
  def change
    create_table :attendees do |t|
      t.string :full_name
      t.string :address
      t.string :org
      t.string :days_to_attend

      t.timestamps
    end
  end
end
