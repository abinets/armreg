class CreateParticipants < ActiveRecord::Migration[7.2]
  def change
    create_table :participants do |t|
      t.string :name
      t.references :organization, null: false, foreign_key: true
      t.date :registration_date
      t.string :location
      t.string :position
      t.string :email
      t.string :telephone_number
      t.references :participant_type, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.string :emergency_contact_name
      t.string :emergency_contact_number
      t.references :side_event, null: false, foreign_key: true
      t.string :meal_options
      t.boolean :resourceMaterial_take
      t.boolean :accommodation_required
      t.text :notes

      t.timestamps
    end
  end
end
