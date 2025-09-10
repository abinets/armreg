class Participant < ApplicationRecord

before_create :generate_serial_number
after_initialize :set_defaults

  belongs_to :user
  broadcasts_refreshes
  belongs_to :group
  belongs_to :side_event
  belongs_to :organization, optional: true 
  belongs_to :participant_type
 
  

  belongs_to :field_visit_activity # Assuming a participant has one activity

  has_many :room_assignments
  has_many :rooms, through: :room_assignments
  has_one_attached :invitation_letter # Add this line
  has_many :field_visit_areas, through: :field_visit_activities


  validates :name, presence: true
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

  def field_visit_activity_name
    field_visit_activity&.name
  end
  def field_visit_activity_km
    field_visit_activity&.notes
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

end

