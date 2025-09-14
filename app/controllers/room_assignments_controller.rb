# app/controllers/room_assignments_controller.rb

class RoomAssignmentsController < ApplicationController
  before_action :set_room_assignment, only: [:show, :edit, :update, :destroy, :assign, :unassign]
  
  # Action to fetch rooms based on participant type
  def rooms_by_participant_type
    respond_to do |format|
      format.json do
        participant = Participant.find(params[:participant_id])
        
        eligible_hotels = participant.participant_type.hotels
        rooms = Room.where(hotel: eligible_hotels).available.includes(:hotel)
        
        render json: rooms.map { |room|
          {
            id: room.id,
            room_name: room.room_number,
            hotel_name: room.hotel&.name
          }
        }
      end
    end
  rescue => e
    render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
  end
  
  # GET /room_assignments
  def index
  @total_rooms = Room.count
  # CORRECTED: The assigned count is now based on RoomAssignment records,
  # which is the source of truth for assignments.
  @assigned_rooms = RoomAssignment.assigned.count
  @hotels = Hotel.includes(:rooms)

  @pagy, @room_assignments = pagy(RoomAssignment.sort_by_params(params[:sort], sort_direction))
end

  # GET /room_assignments/1 or /room_assignments/1.json
  def show
  end

  # GET /room_assignments/new
def new
  @room_assignment = RoomAssignment.new(
    arrived_date: Date.parse('2025-10-21'),
    checkin_date: Date.parse('2025-10-21'),
    checkout_date: Date.parse('2025-10-25')
  )
  @room_assignment.participant_id = params[:participant_id] if params[:participant_id].present?
  @room_assignment.room_id = params[:room_id] if params[:room_id].present?

  @participants = Participant.approved.where.not(id: RoomAssignment.pluck(:participant_id))
  @hotels = Hotel.all
  # Now only shows available rooms
  @rooms = Room.available.all
end

  # GET /room_assignments/1/edit
def edit
  # @participants = Participant.all
  # @hotels = Hotel.all
  # # Shows available rooms plus the currently assigned room
  # @rooms = Room.available.or(Room.where(id: @room_assignment.room_id)).all

  @participants = [@room_assignment.participant]
  @hotels = Hotel.all
  
  # This line ensures the list is filtered to available rooms, but
  # also includes the room that is currently assigned to the participant
  @rooms = Room.available.or(Room.where(id: @room_assignment.room_id)).all
end

  # POST /room_assignments or /room_assignments.json
  def create
    @room_assignment = RoomAssignment.new(room_assignment_params)

    RoomAssignment.transaction do
      if @room_assignment.save
        @room_assignment.assigned!
        
        room = @room_assignment.room
        room.update!(status: :assigned, participant_id: @room_assignment.participant.id)
        room.hotel.decrement!(:rooms_available)

        respond_to do |format|
          format.html { redirect_to @room_assignment, notice: "Room assignment was successfully created." }
          format.json { render :show, status: :created, location: @room_assignment }
        end
      else
        @participants = Participant.approved.where.not(id: RoomAssignment.pluck(:participant_id))
        @hotels = Hotel.all
        @rooms = Room.available.all
        
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @room_assignment.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /room_assignments/1 or /room_assignments/1.json
  def update
    RoomAssignment.transaction do
      if @room_assignment.update(room_assignment_params)
        # Check if the room has been changed
        if @room_assignment.saved_change_to_room_id?
          old_room = Room.find(@room_assignment.room_id_before_last_save)
          new_room = @room_assignment.room
          
          # Free up the old room
          old_room.update!(status: :available, participant_id: nil)
          old_room.hotel.increment!(:rooms_available)
          
          # Assign the new room
          new_room.update!(status: :assigned, participant_id: @room_assignment.participant.id)
          new_room.hotel.decrement!(:rooms_available)
        end
        
        # Ensure status is assigned if it was unassigned
        if @room_assignment.unassigned?
          @room_assignment.assigned!
          @room_assignment.room.update!(status: :assigned, participant_id: @room_assignment.participant.id)
          @room_assignment.room.hotel.decrement!(:rooms_available)
        end
        
        respond_to do |format|
          format.html { redirect_to @room_assignment, notice: "Room assignment was successfully updated." }
          format.json { render :show, status: :ok, location: @room_assignment }
        end
      else
        @participants = Participant.all
        @hotels = Hotel.all
        @rooms = Room.all
        
        respond_to do |format|
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render :show, status: :unprocessable_entity, location: @room_assignment }
        end
      end
    end
  end

  # DELETE /room_assignments/1 or /room_assignments/1.json
  def destroy
    RoomAssignment.transaction do
      room = @room_assignment.room
      @room_assignment.destroy!
      
      room.update!(status: :available)
      room.hotel.increment!(:rooms_available)
    end
    
    respond_to do |format|
      format.html { redirect_to room_assignments_url, status: :see_other, notice: "Room assignment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # Custom action to unassign a room
  def unassign
    RoomAssignment.transaction do
      @room_assignment.unassigned!
      room = @room_assignment.room
      room.update!(status: :available, participant_id: nil)
      room.hotel.increment!(:rooms_available)
    end
    
    respond_to do |format|
      flash[:notice] = "Participant unassigned successfully."
      format.html { redirect_to room_assignments_url }
      format.turbo_stream { redirect_to room_assignments_url, status: :see_other }
    end

  rescue ActiveRecord::RecordInvalid
    respond_to do |format|
      flash[:alert] = "Error unassigning participant."
      format.html { redirect_to room_assignments_url }
      format.turbo_stream { redirect_to room_assignments_url, status: :see_other }
    end
  end

  # Custom action to assign a room
  def assign
    RoomAssignment.transaction do
      @room_assignment.assigned!
      room = @room_assignment.room
      room.update!(status: :assigned, participant_id: @room_assignment.participant.id)
      room.hotel.decrement!(:rooms_available)
    end

    respond_to do |format|
      flash[:notice] = "Participant assigned successfully."
      format.html { redirect_to room_assignments_url }
      format.turbo_stream { redirect_to room_assignments_url, status: :see_other }
    end

  rescue ActiveRecord::RecordInvalid
    respond_to do |format|
      flash[:alert] = "Error assigning participant."
      format.html { redirect_to room_assignments_url }
      format.turbo_stream { redirect_to room_assignments_url, status: :see_other }
    end
  end

  private

  def set_room_assignment
    @room_assignment = RoomAssignment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to room_assignments_path
  end
  
  def room_assignment_params
    params.require(:room_assignment).permit(:participant_id, :room_id, :arrived_date, :checkin_date, :checkout_date, :notes)
  end
end