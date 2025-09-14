class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]

  # GET /rooms
  def index
   @rooms = Room.includes(room_assignments: :participant)

    @pagy, @rooms = pagy(Room.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @rooms
  end

  # GET /rooms/1 or /rooms/1.json
  def show
  end

  # GET /rooms/new
  def new
    @room = Room.new
    @hotels = Hotel.all

    # Uncomment to authorize with Pundit
    # authorize @room
  end

  # GET /rooms/1/edit
  def edit
    @room = Room.find(params[:id])
    @hotels = Hotel.all
  end

  # POST /rooms or /rooms.json
  def create
    @room = Room.new(room_params)
    @hotels = Hotel.all
    # Uncomment to authorize with Pundit
    # authorize @room

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: "Room was successfully created." }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1 or /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to @room, notice: "Room was successfully updated." }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1 or /rooms/1.json
  def destroy
    @room.destroy!
    respond_to do |format|
      format.html { redirect_to rooms_url, status: :see_other, notice: "Room was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def assigned_participant_info
    assignment = room_assignments.find_by(status: :assigned)
    if assignment.present? && assignment.participant.present?
      "Assigned to: #{assignment.participant.name} (Organization: #{assignment.participant.organization&.name})"
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_room
    @room = Room.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @room
  rescue ActiveRecord::RecordNotFound
    redirect_to rooms_path
  end

  # Only allow a list of trusted parameters through.
  def room_params
    params.require(:room).permit(:room_number, :room_type, :floor, :hotel_id)

    # Uncomment to use Pundit permitted attributes
    # params.require(:room).permit(policy(@room).permitted_attributes)
  end
end
