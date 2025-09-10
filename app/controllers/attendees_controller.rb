class AttendeesController < ApplicationController
  before_action :set_attendee, only: [:show, :edit, :update, :destroy]

  # GET /attendees
  def index
    @pagy, @attendees = pagy(Attendee.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @attendees
  end

  # GET /attendees/1 or /attendees/1.json
  def show
  end

  # GET /attendees/new
  def new
    @attendee = Attendee.new

    # Uncomment to authorize with Pundit
    # authorize @attendee
  end

  # GET /attendees/1/edit
  def edit
  end

  # POST /attendees or /attendees.json
  def create
    @attendee = Attendee.new(attendee_params)

    # Uncomment to authorize with Pundit
    # authorize @attendee

    respond_to do |format|
      if @attendee.save
        format.html { redirect_to @attendee, notice: "Attendee was successfully created." }
        format.json { render :show, status: :created, location: @attendee }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @attendee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attendees/1 or /attendees/1.json
  def update
    respond_to do |format|
      if @attendee.update(attendee_params)
        format.html { redirect_to @attendee, notice: "Attendee was successfully updated." }
        format.json { render :show, status: :ok, location: @attendee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @attendee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendees/1 or /attendees/1.json
  def destroy
    @attendee.destroy!
    respond_to do |format|
      format.html { redirect_to attendees_url, status: :see_other, notice: "Attendee was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_attendee
    @attendee = Attendee.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @attendee
  rescue ActiveRecord::RecordNotFound
    redirect_to attendees_path
  end

  # Only allow a list of trusted parameters through.
  def attendee_params
    params.require(:attendee).permit(:full_name, :address, :org, :days_to_attend)

    # Uncomment to use Pundit permitted attributes
    # params.require(:attendee).permit(policy(@attendee).permitted_attributes)
  end
end
