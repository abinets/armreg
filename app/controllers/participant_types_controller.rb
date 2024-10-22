class ParticipantTypesController < ApplicationController
  before_action :set_participant_type, only: [:show, :edit, :update, :destroy]

  # GET /participant_types
  def index
    @pagy, @participant_types = pagy(ParticipantType.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @participant_types
  end

  # GET /participant_types/1 or /participant_types/1.json
  def show
  end

  # GET /participant_types/new
  def new
    @participant_type = ParticipantType.new

    # Uncomment to authorize with Pundit
    # authorize @participant_type
  end

  # GET /participant_types/1/edit
  def edit
  end

  # POST /participant_types or /participant_types.json
  def create
    @participant_type = ParticipantType.new(participant_type_params)

    # Uncomment to authorize with Pundit
    # authorize @participant_type

    respond_to do |format|
      if @participant_type.save
        format.html { redirect_to @participant_type, notice: "Participant type was successfully created." }
        format.json { render :show, status: :created, location: @participant_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @participant_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /participant_types/1 or /participant_types/1.json
  def update
    respond_to do |format|
      if @participant_type.update(participant_type_params)
        format.html { redirect_to @participant_type, notice: "Participant type was successfully updated." }
        format.json { render :show, status: :ok, location: @participant_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @participant_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /participant_types/1 or /participant_types/1.json
  def destroy
    @participant_type.destroy!
    respond_to do |format|
      format.html { redirect_to participant_types_url, status: :see_other, notice: "Participant type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_participant_type
    @participant_type = ParticipantType.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @participant_type
  rescue ActiveRecord::RecordNotFound
    redirect_to participant_types_path
  end

  # Only allow a list of trusted parameters through.
  def participant_type_params
    params.require(:participant_type).permit(:type_name, :description)

    # Uncomment to use Pundit permitted attributes
    # params.require(:participant_type).permit(policy(@participant_type).permitted_attributes)
  end
end
