class CreateOrganizations < ActiveRecord::Migration[7.2]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :location
      t.integer :allowed_participant_number

      t.timestamps
    end
  end
end
