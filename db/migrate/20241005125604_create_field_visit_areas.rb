class CreateFieldVisitAreas < ActiveRecord::Migration[7.2]
  def change
    create_table :field_visit_areas do |t|
      t.string :name
      t.float :distance_from_arm_venue
      t.string :note

      t.timestamps
    end
  end
end
