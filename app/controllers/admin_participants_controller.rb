class AdminParticipantsController < ApplicationController

  
  before_action :set_participant, only: [:approve, :reject, :send_badge_email]
  def index
    @pagy, @field_visit_areas = pagy(FieldVisitArea.sort_by_params(params[:sort], sort_direction))
    @participants = Participant.all
    # Uncomment to authorize with Pundit
    # authorize @field_visit_areas

    if params[:search].present?
      @participants = @participants.where("name ILIKE ? OR email ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    end
    
  end

  def approve
    @participant.update(approved: true)
    redirect_to admin_participants_path, notice: 'Participant approved successfully.'
  end

  def reject
    @participant.update(approved: false)
    redirect_to admin_participants_path, notice: 'Participant rejected successfully.'
  end

  def send_badge_email
    participant = Participant.find(params[:id])
    BadgeMailer.send_badge(participant).deliver_now
    EmailLog.create(participant_id: participant.id, status: 'sent', sent_at: Time.current)
    redirect_to admin_participants_path, notice: 'Badge email sent successfully!'
  rescue StandardError => e
    EmailLog.create(participant_id: participant.id, status: 'failed', sent_at: Time.current)
    redirect_to admin_participants_path, alert: "Failed to send email: #{e.message}"
  end




  private

  def set_participant
    @participant = Participant.find(params[:id])
  end
 
end
