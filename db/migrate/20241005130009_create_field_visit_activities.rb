class CreateFieldVisitActivities < ActiveRecord::Migration[7.2]
  def change
    create_table :field_visit_activities do |t|
      t.string :name
      t.text :description
      t.references :field_visit_area, null: false, foreign_key: true
      t.date :scheduled_date
      t.float :duration
      t.integer :max_participants
      t.text :notes

      t.timestamps
    end
  end
end
