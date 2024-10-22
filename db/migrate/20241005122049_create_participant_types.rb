class CreateParticipantTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :participant_types do |t|
      t.string :type_name
      t.string :description

      t.timestamps
    end
  end
end
