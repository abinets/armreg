class SideEventsController < ApplicationController
  before_action :set_side_event, only: [:show, :edit, :update, :destroy]

  # GET /side_events
  def index
    @pagy, @side_events = pagy(SideEvent.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @side_events
  end

  # GET /side_events/1 or /side_events/1.json
  def show
  end

  # GET /side_events/new
  def new
    @side_event = SideEvent.new

    # Uncomment to authorize with Pundit
    # authorize @side_event
  end

  # GET /side_events/1/edit
  def edit
  end

  # POST /side_events or /side_events.json
  def create
    @side_event = SideEvent.new(side_event_params)

    # Uncomment to authorize with Pundit
    # authorize @side_event

    respond_to do |format|
      if @side_event.save
        format.html { redirect_to @side_event, notice: "Side event was successfully created." }
        format.json { render :show, status: :created, location: @side_event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @side_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /side_events/1 or /side_events/1.json
  def update
    respond_to do |format|
      if @side_event.update(side_event_params)
        format.html { redirect_to @side_event, notice: "Side event was successfully updated." }
        format.json { render :show, status: :ok, location: @side_event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @side_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /side_events/1 or /side_events/1.json
  def destroy
    @side_event.destroy!
    respond_to do |format|
      format.html { redirect_to side_events_url, status: :see_other, notice: "Side event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_side_event
    @side_event = SideEvent.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @side_event
  rescue ActiveRecord::RecordNotFound
    redirect_to side_events_path
  end

  # Only allow a list of trusted parameters through.
  def side_event_params
    params.require(:side_event).permit(:event_name, :description, :startdate, :enddate, :venue)

    # Uncomment to use Pundit permitted attributes
    # params.require(:side_event).permit(policy(@side_event).permitted_attributes)
  end
end
