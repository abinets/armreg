class AddRoomInventoryToHotels < ActiveRecord::Migration[7.2]
  def change
    add_column :hotels, :total_rooms, :integer
    add_column :hotels, :rooms_available, :integer
  end
end
