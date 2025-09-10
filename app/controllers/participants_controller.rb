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
        # html { render } # Default HTML response
      end
      format.xlsx { render xlsx: 'participants', filename: 'participants.xlsx' }
      # format.my_format { render my_format: @participants }
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
    #  authorize @participants
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

  
#   def index
#   # Start with all participants
#   @participants = Participant.all

#   # Apply filters if present
#   @participants = @participants.where("name ILIKE ?", "%#{params[:name]}%") if params[:name].present?
#   @participants = @participants.where("organization_id = ?", params[:organization_id]) if params[:organization_id].present?
#   @participants = @participants.where("location ILIKE ?", "%#{params[:location]}%") if params[:location].present?

#   # Sort and paginate the results
#   @pagy, @participants = pagy(Participant.sort_by_params(@participants, params[:sort], sort_direction))

#   respond_to do |format|
#     format.html do |html|
#       html.tablet { render layout: 'tablet' }
#       html.phone { render layout: 'phone' }
#       # html { render } # Default HTML response
#     end
#     format.xlsx { render xlsx: 'participants', filename: 'participants.xlsx' }
#     # format.my_format { render my_format: @participants }
#   end

#   # Uncomment to authorize with Pundit
#   # authorize @participants
# end

  # GET /participants/1 or /participants/1.json
  def show
  end

  # GET /participants/new
  def new
    @participant = Participant.new
    @organizations = Organization.all
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
    @participant = Participant.find(params[:id])
    @organizations = Organization.all
    @participant_types = ParticipantType.all
    @groups = Group.all
    @side_events = SideEvent.all
    @field_visit_activities = FieldVisitActivity.all

    @users = User.all

  end

  # POST /participants or /participants.json
  def create

    @participant = Participant.new(participant_params)
    @participant.user_id = current_user.id 
    @organizations = Organization.all
    @participant_types = ParticipantType.all
    @groups = Group.all
    @field_visit_activities = FieldVisitActivity.all
    @side_events = SideEvent.all

    if params[:participant][:other_organization_name].present?
      new_organization = Organization.create(name: params[:participant][:other_organization_name])
      @participant.organization_id = new_organization.id
    end

    # Uncomment to authorize with Pundit
    # authorize @participant

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

  # PATCH/PUT /participants/1 or /participants/1.json
  def update
    @organization = Organization.all
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
      :rooms # Eager load rooms through room assignments
    ).where(approved: true).distinct
  
    respond_to do |format|
      format.xlsx do
        # Create a new package
        package = Axlsx::Package.new
  
        # Add a workbook to the package
        package.workbook.add_worksheet(name: 'Participants') do |sheet|
          # Define styles
          red_style = package.workbook.styles.add_style(bg_color: 'a000a0', fg_color: 'FFFFFF', num_fmt: 0) # Red background, white text
          vip_style = package.workbook.styles.add_style(bg_color: 'FFFFFF', fg_color: 'a00000', num_fmt: 0) # Red background, white text


       header_style = package.workbook.styles.add_style(
          bg_color: '0000FF',    # Blue background
          fg_color: 'FFFFFF',     # White text
          b: true,                # Bold text
          sz: 12,                 # Font size
          alignment: { horizontal: :center } )          # Add header row with additional attributes
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
            'Allocated Hotel'  # Column for Allocated Hotel
          ] , style: header_style 
  num = 1
          # Add participant data rows
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
              participant.rooms.any? ? participant.rooms.map { |room| "#{room.hotel_name} (#{room.room_number})" }.join(', & ') : 'N/A' # Check if rooms are present
            ]
  
            # Determine if the row should be styled
            num = num + 1

            if row_data.last == 'N/A'
              sheet.add_row row_data, style: red_style # Apply red style if allocated hotel is 'N/A'
            elsif  row_data.participant.participant_type_name  == 'VIP'
              sheet.add_row row_data, style: vip_style 
            else
              sheet.add_row row_data # Add row without special styling
            end
          end
        end
  
        # Send the Excel file
        send_data package.to_stream.read, 
                  filename: 'participants.xlsx', 
                  type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                  disposition: 'attachment'
      end
  
      format.html { render :index }  
    end
  end
  
  
  # def export
  #   # @participants = Participant.includes(
  #   #   :organization, 
  #   #   :participant_type, 
  #   #   :rooms # Eager load rooms through room assignments
  #   # ).where(room_assignments: { status: 1 })
  #   # .distinct

  #   @participants = Participant.includes(
  #     :organization, 
  #     :participant_type, 
  #     :rooms # Eager load rooms through room assignments
  #   ).distinct # Ensure we join room_assignments
  #   # Filter by room assignment status
    
  #   respond_to do |format|
  #     format.xlsx do
  #       # Create a new package
  #       package = Axlsx::Package.new
  
  #       # Add a workbook to the package
  #       package.workbook.add_worksheet(name: 'Participants') do |sheet|

  #         red_style = package.workbook.styles.add_style(bg_color: 'FF0000', fg_color: 'FFFFFF', num_fmt: 0) # Red background, white text
  #         # Add header row with additional attributes
  #         sheet.add_row [
  #           'Badge ID', 
  #           'Name', 
  #           'Organization', 
  #           'Location', 
  #           'Position', 
  #           'Email', 
  #           'Telephone Number', 
  #           'Participant Type', 
  #           'Group Number', 
  #           'Allocated Hotel'  # Column for Allocated Hotel
  #         ] 
  
  #         # Add participant data rows
  #         @participants.each do |participant|
  #           sheet.add_row [
  #             participant.serial_number,
  #             participant.name,
  #             participant.organization&.name, 
  #             participant.location,
  #             participant.position,
  #             participant.email,
  #             participant.telephone_number,
  #             participant.participant_type_name, 
  #             participant.group_name, 
  #             participant.rooms.any? ? participant.rooms.map { |room| "#{room.hotel_name} (#{room.room_number})" }.join(', & ') : '-- Not Assigned' 
  #           ]

  #           if row_data.last == '-- Not Assigned'
  #             sheet.add_row row_data, style: red_style # Apply red style if allocated hotel is 'N/A'
  #           else
  #             sheet.add_row row_data # Add row without special styling
  #           end

  #         end
  #       end
  
  #       # Send the Excel file
  #       send_data package.to_stream.read, 
  #                 filename: 'participants.xlsx', 
  #                 type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  #                 disposition: 'attachment'
  #     end
  
  #     format.html { render :index }  
  #   end
  # end


  # def export
  #   @participants = Participant.includes(
  #     :organization, 
  #     :participant_type, 
  #     # :field_visit_activity, 
  #     :rooms # Eager load rooms through room assignments
  #   ).where(room_assignments: { status: 1 })
  #   .distinct


  #   # @participants = Participant.joins(:room_assignments)
  #   # .includes(:organization, :participant_type, :rooms)
  #   # .where(room_assignments: { status: 1 })
  #   # .distinct # Use distinct to avoid duplicate participants if they have multiple assignments


  #   respond_to do |format|
  #     format.xlsx do
  #       # Create a new package
  #       package = Axlsx::Package.new

  #       # Add a workbook to the package
  #       package.workbook.add_worksheet(name: 'Participants') do |sheet|
  #         # Add header row with additional attributes
  #         sheet.add_row [
  #           'Badge ID', 
  #           'Name', 
  #           'Organization', 
  #           'Location', 
  #           'Position', 
  #           'Email', 
  #           'Telephone Number', 
  #           'Participant Type', 
  #           'Group Number', 
  #           # 'Field Visit Activity', 

  #           'Allocated Hotel'  
  #         ] 

  #         # Add participant data rows
  #         @participants.each do |participant|
  #           sheet.add_row [
  #             participant.serial_number,
  #             participant.name,
  #             participant.organization&.name, 
  #             participant.location,
  #             participant.position,
  #             participant.email,
  #             participant.telephone_number,
  #             participant.participant_type_name, # Accessing name from participant_type
  #             participant.group_name, # Accessing name from field_visit_area
  #             participant.rooms.any? ? participant.rooms.map { |room| "#{room.hotel_name} (#{room.room_number})" }.join(', & ') : 'N/A'             ]
  #         end
  #       end

  #       # Send the Excel file
  #       send_data package.to_stream.read, 
  #                 filename: 'participants.xlsx', 
  #                 type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  #                 disposition: 'attachment'
  #     end

  #     format.html { render :index }  
  #   end
  # end



  # def import
  #   # if params[:file].nil?
  #   #   flash[:alert] = "Please upload a file."
  #   #   redirect_to participants_path and return
  #   # end

  #   xlsx = Roo::Spreadsheet.open(path[:xlsx_path])
  #   xlsx.sheet(0).each_with_index(firstname: 'Name', registration_date: 'Registration Date', 
  #   location: 'Location', email: 'Email', position: 'Position') do |row, row_index|

  #   # spreadsheet = Roo::Spreadsheet.open(params[:file].path)

  #   # header = spreadsheet.row(1)

  #   # (2..spreadsheet.last_row).each do |i|
  #   #   row = Hash[[header.zip(spreadsheet.row(i))]]
  #   next if row_index == 0 || Participant.find_by(name: row[:name]).present?


  #     # Create or update a participant without serial_number
  #     Participant.create!(
  #       name: row['Name'],
  #       organization_id: Organization.find_or_create_by(name: row['Organization']).id,
  #       registration_date: row['Registration Date'],
  #       field_visit_activity_id: FieldVisitActivity.find_by(name: row['Field Visit Activity'])&.id,
  #       invitation_letter: row['Invitation Letter'],
  #       location: row['Location'],
  #       position: row['Position'],
  #       email: row['Email'],
  #       telephone_number: row['Telephone Number'],
  #       participant_type_id: ParticipantType.find_by(name: row['Participant Type'])&.id,
  #       group_id: Group.find_by(name: row['Group'])&.id,
  #       emergency_contact_name: row['Emergency Contact Name'],
  #       emergency_contact_number: row['Emergency Contact Number'],
  #       side_event_id: SideEvent.find_by(name: row['Side Event'])&.id,
  #       meal_options: row['Meal Options'],
  #       resourceMaterial_take: row['Resource Material Take'],
  #       accommodation_required: row['Accommodation Required'],
  #       notes: row['Notes'],
  #       attended_day_0: row['Attended Day 0'],
  #       attended_day_1: row['Attended Day 1'],
  #       attended_day_2: row['Attended Day 2'],
  #       attended_day_3: row['Attended Day 3'],
  #     )
  #   end

  #   flash[:notice] = "Participants imported successfully."
  #   redirect_to participants_path
  # rescue => e
  #   flash[:alert] = "Error importing participants: #{e.message}"
  #   redirect_to participants_path
  # end

  def import
    Participant.import(params[:file])
    redirect_to import_participants_path
  end

  def import
    if params[:file].present?
      begin
        # Read and process the CSV file
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

    # Uncomment to authorize with Pundit
    # authorize @participant
  rescue ActiveRecord::RecordNotFound
    redirect_to participants_path
  end

  

 
  # Only allow a list of trusted parameters through.
  def participant_params
    params.require(:participant).permit(:serial_number, :name, :organization_id, :region, :registration_date, :field_visit_activity_id, :invitation_letter, :location, :position, :email, :telephone_number, :participant_type_id, :group_id, :emergency_contact_name, :emergency_contact_number, :side_event_id, :meal_options, :resourceMaterial_take, :accommodation_required, :notes, :attended_day_0, :attended_day_1, :attended_day_2, :attended_day_3, :orgname)

    # Uncomment to use Pundit permitted attributes
    # params.require(:participant).permit(policy(@participant).permitted_attributes)
  end
end
