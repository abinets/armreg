# app/models/participant.rb

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
  has_one_attached :invitation_letter 
  has_many :field_visit_areas, through: :field_visit_activities

  # NEW: Adds photo upload functionality
  has_one_attached :photo

  # This is the scope that defines the `approved` method.
  scope :approved, -> { where(approved: true) }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :telephone_number, presence: true
  
  # New validation to prevent assigning a participant to more than one room
  validate :is_not_already_assigned, on: :create
  
  # NEW: Validations for the photo
  validate :correct_photo_content_type
  # validate :correct_photo_dimensions

  def is_not_already_assigned
    if RoomAssignment.exists?(participant_id: self.id)
      errors.add(:base, "Participant is already assigned to a room")
    end
  end

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
    self.serial_number = "ARM27#{participant_type_id}#{format('%04d', next_number)}"
  end
  
  # NEW: Method to validate the photo content type
  def correct_photo_content_type
    if photo.attached? && !photo.content_type.in?(['image/jpeg', 'image/png', 'image/gif'])
      errors.add(:photo, 'must be a JPEG, PNG, or GIF')
    end
  end

  # NEW: Method to validate the photo dimensions
  def correct_photo_dimensions
  #   if photo.attached?
  #     # Ensure you have 'mini_magick' gem in your Gemfile
  #     # gem 'mini_magick'
  #     photo_metadata = photo.blob.metadata
  #     unless photo_metadata[:width] == 300 && photo_metadata[:height] == 300
  #       errors.add(:photo, 'must be 300x300 pixels')
  #     end
  #   end
  # rescue
  #   # Handle cases where the file is not a valid image
  #   errors.add(:photo, 'could not be processed')
  end
end