class AddSerialNumberToParticipants < ActiveRecord::Migration[7.2]
  def change
    add_column :participants, :serial_number, :string
  end
end
