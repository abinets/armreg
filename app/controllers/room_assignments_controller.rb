class RoomAssignmentsController < ApplicationController
  before_action :set_room_assignment, only: [:show, :edit, :update, :destroy, :assign, :unassign]
  before_action :load_hotels, only: %i[new create edit]
  before_action :load_participants, only: %i[new create edit]
  before_action :load_unassigned_participants, only: %i[new create edit]
  before_action :load_free_rooms, only: [:index]
  
  # GET /room_assignments
  def index
    @pagy, @room_assignments = pagy(RoomAssignment.sort_by_params(params[:sort], sort_direction))
    @room_assignments = RoomAssignment.all
    # Uncomment to authorize with Pundit
    # authorize @room_assignments
  end

  # GET /room_assignments/1 or /room_assignments/1.json
  def show
  end

  # GET /room_assignments/new
  def new
    @room_assignment = RoomAssignment.new
    @room_assignment.participant_id = params[:participant_id] if params[:participant_id].present?

    # @participants = Participant.where(room_assignments: { status: 0 }).joins(:room_assignments).distinct
    @participants = Participant.left_outer_joins(:room_assignments)
                           .where("room_assignments.status = ? OR room_assignments.id IS NULL", 0)
                           .distinct.where.not(id: RoomAssignment.where(status: 1).select(:participant_id))

    @room_assignment.room_id = params[:room_id] if params[:room_id].present?


    
    # Uncomment to authorize with Pundit
    # authorize @room_assignment
  end

  # GET /room_assignments/1/edit
  def edit
  end

  # POST /room_assignments or /room_assignments.json
  def create
    @room_assignment = RoomAssignment.new(room_assignment_params)
    @room_assignment.status = RoomAssignment::STATUS_ASSIGNED

    # Uncomment to authorize with Pundit
    # authorize @room_assignment

    respond_to do |format|
      if @room_assignment.save
        format.html { redirect_to @room_assignment, notice: "Room assignment was successfully created." }
        format.json { render :show, status: :created, location: @room_assignment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @room_assignment.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /room_assignments/1 or /room_assignments/1.json
  def update
    respond_to do |format|
      if @room_assignment.update(room_assignment_params)
        format.html { redirect_to @room_assignment, notice: "Room assignment was successfully updated." }
        format.json { render :show, status: :ok, location: @room_assignment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @room_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /room_assignments/1 or /room_assignments/1.json
  def destroy
    @room_assignment.destroy!
    respond_to do |format|
      format.html { redirect_to room_assignments_url, status: :see_other, notice: "Room assignment was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  def unassign
    @room_assignment = RoomAssignment.find(params[:id]) # Find the RoomAssignment by ID

    if @room_assignment.update(status: 0) # Update status to 0 for unassigning
      flash[:notice] = "Participant unassigned successfully."
      redirect_to room_path(@room_assignment.room) # Redirect to the room view
    else
      flash[:alert] = "Error unassigning participant."
      redirect_to room_path(@room_assignment.room) # Redirect back to the room view
    end
  end

  def assign
    @room_assignment = RoomAssignment.find(params[:id])
    @room_assignment.change_status(RoomAssignment::STATUS_ASSIGNED)
    
    if @room_assignment.save
      flash[:notice] = "Participant assigned successfully."
      redirect_to room_assignments_url 
    else
      flash[:alert] = "Error assigning participant."
      redirect_to room_assignments_url 
    end
  end


  def rooms_by_hotel
    @rooms = Room.where(hotel_id: params[:hotel_id])
    respond_to do |format|
      format.json { render json: @rooms }
    end
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_room_assignment
    @room_assignment = RoomAssignment.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @room_assignment
  rescue ActiveRecord::RecordNotFound
    redirect_to room_assignments_path
  end

  def load_participants
    @participants = Participant.all
  end

  def load_unassigned_participants
    # Assuming there is a RoomAssignment model that connects participants to rooms
    assigned_participant_ids = RoomAssignment.pluck(:participant_id)
    @participants = Participant.where.not(id: assigned_participant_ids)
  end
  def load_free_rooms
    assigned_room_ids = RoomAssignment.pluck(:room_id)
    @free_rooms = Room.where.not(id: assigned_room_ids)
  end

  def load_hotels
    @hotels = Hotel.all
  end

  # Only allow a list of trusted parameters through.
  def room_assignment_params
    params.require(:room_assignment).permit(:participant_id, :room_id, :arrived_date, :checkin_date, :checkout_date, :notes)

    # Uncomment to use Pundit permitted attributes
    # params.require(:room_assignment).permit(policy(@room_assignment).permitted_attributes)
  end
end
