# lib/tasks/data_fix.rake
namespace :data do
  desc "Fixes inconsistent room statuses based on participant_id"
  task fix_room_statuses: :environment do
    puts "Starting data consistency check for Room statuses..."

    Room.all.each do |room|
      if room.participant_id.present?
        # If a room has a participant, it must be assigned.
        if !room.assigned?
          room.update!(status: :assigned)
          puts "Fixed room ##{room.id} status to 'assigned'."
        end
      else
        # If a room does NOT have a participant, it must be available.
        if room.assigned?
          room.update!(status: :available)
          puts "Fixed room ##{room.id} status to 'available'."
        end
      end
    end

    puts "Data consistency check complete."
  end
end