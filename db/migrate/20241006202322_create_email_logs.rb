class CreateEmailLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :email_logs do |t|
      t.integer :participant_id
      t.string :status
      t.datetime :sent_at

      t.timestamps
    end
  end
end
