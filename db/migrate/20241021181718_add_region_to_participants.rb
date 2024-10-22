class AddRegionToParticipants < ActiveRecord::Migration[7.2]
  def change
    add_column :participants, :region, :string
  end
end
