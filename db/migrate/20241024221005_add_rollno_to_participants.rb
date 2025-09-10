class AddRollnoToParticipants < ActiveRecord::Migration[7.2]
  def change
    add_column :participants, :rollno, :string
  end
end
