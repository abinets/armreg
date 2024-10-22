class Participant < ApplicationRecord

before_create :generate_serial_number
after_initialize :set_defaults

  belongs_to :user
  broadcasts_refreshes
  belongs_to :group
  belongs_to :side_event
  belongs_to :organization
  belongs_to :participant_type
  belongs_to :gender, optional: true

  belongs_to :field_visit_activity # Assuming a participant has one activity

  has_many :room_assignments
  has_many :rooms, through: :room_assignments
  has_one_attached :invitation_letter # Add this line


  validates :name, presence: true
  validates :organization, presence: true
  validates :email, presence: true, uniqueness: true
  validates :telephone_number, presence: true


  def organization_name
    organization&.name
  end

  def group_name
    group&.name
  end
  def side_event_name
    side_event&.event_name
  end

  def participant_type_name
    participant_type&.type_name
  end


  
  private

  
  def set_defaults
    self.attended_day_0 ||= false
    self.attended_day_1 ||= false
    self.attended_day_2 ||= false
    self.attended_day_3 ||= false
  end


  def generate_serial_number
    return unless participant_type_id.present?
  
    last_serial_number = Participant.where(participant_type_id: participant_type_id)
                                     .where("SUBSTRING(serial_number, 9) ~ '^[0-9]+$'") # Filter for numeric values
                                     .maximum("CAST(SUBSTRING(serial_number, 9) AS INTEGER)")
  
    next_number = last_serial_number ? last_serial_number + 1 : 1
    self.serial_number = "ARM26#{participant_type_id}#{format('%04d', next_number)}"
  end

  def self.import(file)
    xlsx = Roo::Excelx.new(file.tempfile)
    xlsx.each_row_streaming(offset: 1) do |row|
      participant = self.new(name: row[0].value,
      name: row['Name'],
      
      organization_id: Organization.find_or_create_by(name: row['Organization']).id,
      registration_date: row['Registration Date'],
      field_visit_activity_id: FieldVisitActivity.find_by(name: row['Field Visit Activity'])&.id,
      invitation_letter: row['Invitation Letter'],
      location: row['Location'],
      position: row['Position'],
      email: row['Email'],
      telephone_number: row['Telephone Number'],
      participant_type_id: ParticipantType.find_by(name: row['Participant Type'])&.id,
      group_id: Group.find_by(name: row['Group'])&.id,
      emergency_contact_name: row['Emergency Contact Name'],
      emergency_contact_number: row['Emergency Contact Number'],
      side_event_id: SideEvent.find_by(name: row['Side Event'])&.id,
      meal_options: row['Meal Options'],
      resourceMaterial_take: row['Resource Material Take'],
      accommodation_required: row['Accommodation Required'],
      notes: row['Notes'],
      attended_day_0: row['Attended Day 0'],
      attended_day_1: row['Attended Day 1'],
      attended_day_2: row['Attended Day 2'],
      attended_day_3: row['Attended Day 3'])

      next if self.pluck(:id).include?(participant.id)
      participant.save
    end
  end



  # def self.import(file)

  
  #   begin
  #     spreadsheet = Roo::Spreadsheet.open('/Users/madc/Downloads/participants_13.xlsx')
  #     header = spreadsheet.row(1)
  
  #     (2..spreadsheet.last_row).each do |i|
  #       row_data = spreadsheet.row(i)
  
  #       # Log the header and row length for debugging
  #       Rails.logger.debug("Header: #{header.inspect} (Length: #{header.size})")
  #       Rails.logger.debug("Row #{i}: #{row_data.inspect} (Length: #{row_data.size})")
  
  #       # Check if the lengths match before creating the hash
  #       if row_data.size == header.size
  #         row = Hash[[header.zip(row_data)]]
  
  #         # Create or update a participant
  #         Participant.create!(
  #           name: row['Name'],
  #           organization_id: Organization.find_or_create_by(name: row['Organization']).id,
  #           registration_date: row['Registration Date'],
  #           field_visit_activity_id: FieldVisitActivity.find_by(name: row['Field Visit Activity'])&.id,
  #           invitation_letter: row['Invitation Letter'],
  #           location: row['Location'],
  #           position: row['Position'],
  #           email: row['Email'],
  #           telephone_number: row['Telephone Number'],
  #           participant_type_id: ParticipantType.find_by(name: row['Participant Type'])&.id,
  #           group_id: Group.find_by(name: row['Group'])&.id,
  #           emergency_contact_name: row['Emergency Contact Name'],
  #           emergency_contact_number: row['Emergency Contact Number'],
  #           side_event_id: SideEvent.find_by(name: row['Side Event'])&.id,
  #           meal_options: row['Meal Options'],
  #           resourceMaterial_take: row['Resource Material Take'],
  #           accommodation_required: row['Accommodation Required'],
  #           notes: row['Notes'],
  #           attended_day_0: row['Attended Day 0'],
  #           attended_day_1: row['Attended Day 1'],
  #           attended_day_2: row['Attended Day 2'],
  #           attended_day_3: row['Attended Day 3']
  #         )
  #       else
  #         Rails.logger.warn("Row #{i} has an incorrect number of elements: #{row_data.size} (expected #{header.size})")
  #       end
  #     end
  
  #     flash[:notice] = "Participants imported successfully."
  #   rescue StandardError => e
  #     Rails.logger.error("Error importing participants: #{e.message}")
  #     flash[:alert] = "Error importing participants: #{e.message}"
  #   ensure
  #     redirect_to participants_path
  #   end
  # end


end

