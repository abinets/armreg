class DashboardController < ApplicationController
  def show

    @total_participants = Participant.count
    @total_approved_participants = Participant.where(approved: true).count
    @total_rooms = Room.count
    @allocated_rooms = RoomAssignment.count
    @free_rooms = Room.where.not(id: RoomAssignment.pluck(:room_id)).count

  end

def index
  @participant = Participant.find(params[:id])
  # @participants = Participant.all
  # @participant_types = ParticipantType.all

  # @organizations = Organization.all

  # @groups = Group.all
  # @field_visit_activities = FieldVisitActivity.all
  # @side_events = SideEvent.all
end
  
def doubled_participant
   @participant = Participant.find(params[:id])
end


  def download_pdf
    @participant = Participant.find(params[:id])
    
    respond_to do |format|
      format.html { render plain: "Only PDF format is supported for this URL." }
      format.pdf do
        render pdf: "badge_#{@participant.serial_number}",
               template: "dashboard/doubled_participant",
               layout: false # To prevent Rails from looking for a separate PDF layout
      end
    end
  end
  
def doubled
    @participants = Participant.all
    @participant_types = ParticipantType.all
  
    @organizations = Organization.all
  
    @groups = Group.all
    @field_visit_activities = FieldVisitActivity.all
    @side_events = SideEvent.all
  end


  def badges_pdf
    @participants = Participant.all
    respond_to do |format|
      format.html # This will render the standard index view
      format.pdf do
        render pdf: "badges",   # Name of the PDF file
               template: "dashboard/badges_pdf.html.erb", # Template to render
               layout: 'pdf.html', # Optional layout for PDF
               page_size: 'A4',    # Size of the PDF
               orientation: 'Portrait' # Orientation
      end
    end
  end

end
