class CreateSideEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :side_events do |t|
      t.string :event_name
      t.string :description
      t.date :startdate
      t.date :enddate
      t.string :venue

      t.timestamps
    end
  end
end
