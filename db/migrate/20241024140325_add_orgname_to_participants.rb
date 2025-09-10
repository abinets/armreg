class AddOrgnameToParticipants < ActiveRecord::Migration[7.2]
  def change
    add_column :participants, :orgname, :string
  end
end
