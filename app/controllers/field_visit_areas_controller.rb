class FieldVisitAreasController < ApplicationController
  before_action :set_field_visit_area, only: [:show, :edit, :update, :destroy]

  # GET /field_visit_areas
  def index
    @pagy, @field_visit_areas = pagy(FieldVisitArea.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @field_visit_areas
  end

  # GET /field_visit_areas/1 or /field_visit_areas/1.json
  def show
  end

  # GET /field_visit_areas/new
  def new
    @field_visit_area = FieldVisitArea.new

    # Uncomment to authorize with Pundit
    # authorize @field_visit_area
  end

  # GET /field_visit_areas/1/edit
  def edit
  end

  # POST /field_visit_areas or /field_visit_areas.json
  def create
    @field_visit_area = FieldVisitArea.new(field_visit_area_params)

    # Uncomment to authorize with Pundit
    # authorize @field_visit_area

    respond_to do |format|
      if @field_visit_area.save
        format.html { redirect_to @field_visit_area, notice: "Field visit area was successfully created." }
        format.json { render :show, status: :created, location: @field_visit_area }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @field_visit_area.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /field_visit_areas/1 or /field_visit_areas/1.json
  def update
    respond_to do |format|
      if @field_visit_area.update(field_visit_area_params)
        format.html { redirect_to @field_visit_area, notice: "Field visit area was successfully updated." }
        format.json { render :show, status: :ok, location: @field_visit_area }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @field_visit_area.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /field_visit_areas/1 or /field_visit_areas/1.json
  def destroy
    @field_visit_area.destroy!
    respond_to do |format|
      format.html { redirect_to field_visit_areas_url, status: :see_other, notice: "Field visit area was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_field_visit_area
    @field_visit_area = FieldVisitArea.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @field_visit_area
  rescue ActiveRecord::RecordNotFound
    redirect_to field_visit_areas_path
  end

  # Only allow a list of trusted parameters through.
  def field_visit_area_params
    params.require(:field_visit_area).permit(:name, :distance_from_arm_venue, :note)

    # Uncomment to use Pundit permitted attributes
    # params.require(:field_visit_area).permit(policy(@field_visit_area).permitted_attributes)
  end
end
