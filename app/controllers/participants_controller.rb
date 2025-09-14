require 'roo'
class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:show, :edit, :update, :destroy, :mark_attended, :import]
  before_action :authenticate_user! , except: [:detailed, :printbadge]

  # GET /participants
  def index
    @pagy, @participants = pagy(Participant.sort_by_params(params[:sort], sort_direction))
    
    respond_to do |format|
      format.html do |html|
        html.tablet { render layout: 'tablet' }
        html.phone { render layout: 'phone' }
      end
      format.xlsx { render xlsx: 'participants', filename: 'participants.xlsx' }
    end

    if params[:name].present?
      @participants = @participants.where("name ILIKE ?", "%#{params[:name]}%")
    end

    if params[:orgname].present?
      @participants = @participants.where("orgname ILIKE ?", "%#{params[:orgname]}%")
    end

    if params[:location].present?
      @participants = @participants.where("location ILIKE ?", "%#{params[:location]}%")
    end

    # Uncomment to authorize with Pundit
    # authorize @participants
  end

  def detailed
    @participant = Participant.find_by(serial_number: params[:serial_number])
    
    if @participant.nil?
      redirect_to participants_path, alert: "Participant not found."
    end
  end

  def printbadge
    @participant = Participant.find_by(serial_number: params[:serial_number])
    @participant_types = ParticipantType.all
    @organizations = Organization.all
    @groups = Group.all
    @field_visit_activities = FieldVisitActivity.all
    @side_events = SideEvent.all
  end 

  # GET /participants/1 or /participants/1.json
  def show
  end

  # GET /participants/new
  def new
    @participant = Participant.new
    # Correctly adds the 'Other' option to the organizations list
    @organizations = Organization.all.to_a.insert(0, OpenStruct.new(id: 0, name: "Other (please specify)"))
    @participant_types = ParticipantType.all
    @groups = Group.all
    @side_events = SideEvent.all
    @field_visit_activities = FieldVisitActivity.all
    @participant.name = params[:name] if params[:name].present?
    @participant.email = params[:email] if params[:email].present?
  
    # Uncomment to authorize with Pundit
    # authorize @participant
  end

  # GET /participants/1/edit
  def edit
    # Correctly adds the 'Other' option to the organizations list
    @organizations = Organization.all.to_a.insert(0, OpenStruct.new(id: 0, name: "Other (please specify)"))
    @participant_types = ParticipantType.all
    @groups = Group.all
    @side_events = SideEvent.all
    @field_visit_activities = FieldVisitActivity.all

    @users = User.all
  end

  # POST /participants or /participants.json
def create
  @participant = Participant.new(participant_params)

  # FINAL LOGIC: Check if a new organization name was provided from the form field
  if params[:new_organization_name].present?
    # Find or create the organization in the organizations table
    new_org = Organization.find_or_create_by(name: params[:new_organization_name])
    
    # Set both the foreign key AND the orgname column on the participant
    @participant.organization = new_org
    @participant.orgname = new_org.name
  end

  @participant.user_id = current_user.id
  
  # Re-initialize variables for the form on render
  @organizations = Organization.all
  @participant_types = ParticipantType.all
  @groups = Group.all
  @side_events = SideEvent.all
  @field_visit_activities = FieldVisitActivity.all
  
  respond_to do |format|
    if @participant.save
      format.html { redirect_to @participant, notice: "Your Participant Information is successfully created." }
      format.json { render :show, status: :created, location: @participant }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @participant.errors, status: :unprocessable_entity }
    end
  end
end

def update
  # FINAL LOGIC: Check if a new organization name was provided from the form field
  if params[:new_organization_name].present?
    # Find or create the organization in the organizations table
    new_org = Organization.find_or_create_by(name: params[:new_organization_name])
    
    # Update both the foreign key AND the orgname column in the parameters
    params[:participant][:organization_id] = new_org.id
    params[:participant][:orgname] = new_org.name
  end

  @organizations = Organization.all
  @participant_types = ParticipantType.all
  @groups = Group.all
  @side_events = SideEvent.all
  @field_visit_activities = FieldVisitActivity.all

  respond_to do |format|
    if @participant.update(participant_params)
      format.html { redirect_to @participant, notice: "Participant was successfully updated." }
      format.json { render :show, status: :ok, location: @participant }
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @participant.errors, status: :unprocessable_entity }
    end
  end
end

  def mark_attended
    if @participant.update(attended_day_1: true)
      redirect_to @participant, notice: 'Participant marked as attended on day 1.'
    else
      redirect_to @participant, alert: 'Failed to mark participant as attended.'
    end
  end

  def export
    @participants = Participant.includes(
      :organization, 
      :participant_type, 
      :rooms
    ).where(approved: true).distinct
  
    respond_to do |format|
      format.xlsx do
        package = Axlsx::Package.new
  
        package.workbook.add_worksheet(name: 'Participants') do |sheet|
          red_style = package.workbook.styles.add_style(bg_color: 'a000a0', fg_color: 'FFFFFF', num_fmt: 0)
          vip_style = package.workbook.styles.add_style(bg_color: 'FFFFFF', fg_color: 'a00000', num_fmt: 0)
          header_style = package.workbook.styles.add_style(
            bg_color: '0000FF',
            fg_color: 'FFFFFF',
            b: true,
            sz: 12,
            alignment: { horizontal: :center }
          )
          
          sheet.add_row [
            'No.',
            'Roll No.',
            'Badge ID', 
            'Name', 
            'Organization', 
            'Location', 
            'Position', 
            'Email', 
            'Telephone Number', 
            'Participant Type', 
            'Group Number', 
            'Field Activity ', 
            'Allocated Hotel'
          ], style: header_style
  
          num = 1
          @participants.each do |participant|
            row_data = [
              num,
              participant.rollno,
              participant.serial_number,
              participant.name,
              participant.orgname, 
              participant.location,
              participant.position,
              participant.email,
              participant.telephone_number,
              participant.participant_type_name, 
              participant.group_name, 
              participant.field_visit_activity_name,
              participant.rooms.any? ? participant.rooms.map { |room| "#{room.hotel_name} (#{room.room_number})" }.join(', & ') : 'N/A'
            ]
            
            num += 1

            if row_data.last == 'N/A'
              sheet.add_row row_data, style: red_style
            elsif participant.participant_type_name == 'VIP'
              sheet.add_row row_data, style: vip_style 
            else
              sheet.add_row row_data
            end
          end
        end
  
        send_data package.to_stream.read, 
                  filename: 'participants.xlsx', 
                  type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                  disposition: 'attachment'
      end
  
      format.html { render :index }  
    end
  end
  
  def import
    if params[:file].present?
      begin
        CSV.foreach(params[:file].path, headers: true) do |row|
          Participant.create!(participant_params(row))
        end
        redirect_to participants_path, notice: 'Participants imported successfully.'
      rescue StandardError => e
        redirect_to import_participants_path, alert: "Error importing participants: #{e.message}"
      end
    else
      redirect_to import_participants_path, alert: 'Please upload a CSV file.'
    end
  end

  # DELETE /participants/1 or /participants/1.json
  def destroy
    @participant.destroy!
    respond_to do |format|
      format.html { redirect_to participants_url, status: :see_other, notice: "Participant was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_participant
    @participant = Participant.find(params[:id])
    # authorize @participant
  rescue ActiveRecord::RecordNotFound
    redirect_to participants_path
  end

  # Only allow a list of trusted parameters through.
  def participant_params
    params.require(:participant).permit(
      :name, :orgname, :region, :location, :registration_date, :email, :telephone_number, 
      :emergency_contact_name, :emergency_contact_number, :invitation_letter, 
      :position, :organization_id, 
      :participant_type_id, :field_visit_activity_id, :group_id, :side_event_id, 
      :meal_options, :resourceMaterial_take, :accommodation_required, :notes,
      :photo
    )
  end
end