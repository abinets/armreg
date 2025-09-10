class FieldVisitActivitiesController < ApplicationController
  before_action :set_field_visit_activity, only: [:show, :edit, :update, :destroy]

  # GET /field_visit_activities
  def index
    @pagy, @field_visit_activities = pagy(FieldVisitActivity.sort_by_params(params[:sort], sort_direction))
    @field_visit_areas = FieldVisitArea.all
    # Uncomment to authorize with Pundit
    # authorize @field_visit_activities
  end

  # GET /field_visit_activities/1 or /field_visit_activities/1.json
  def show
  end

  # GET /field_visit_activities/new
  def new
    @field_visit_activity = FieldVisitActivity.new
    @field_visit_areas = FieldVisitArea.all

    # Uncomment to authorize with Pundit
    # authorize @field_visit_activity
  end

  # GET /field_visit_activities/1/edit
  def edit
    @field_visit_areas = FieldVisitArea.all
  end

  # POST /field_visit_activities or /field_visit_activities.json
  def create
    @field_visit_activity = FieldVisitActivity.new(field_visit_activity_params)

    # Uncomment to authorize with Pundit
    # authorize @field_visit_activity

    respond_to do |format|
      if @field_visit_activity.save
        format.html { redirect_to @field_visit_activity, notice: "Field visit activity was successfully created." }
        format.json { render :show, status: :created, location: @field_visit_activity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @field_visit_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /field_visit_activities/1 or /field_visit_activities/1.json
  def update
    respond_to do |format|
      if @field_visit_activity.update(field_visit_activity_params)
        format.html { redirect_to @field_visit_activity, notice: "Field visit activity was successfully updated." }
        format.json { render :show, status: :ok, location: @field_visit_activity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @field_visit_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /field_visit_activities/1 or /field_visit_activities/1.json
  def destroy
    @field_visit_activity.destroy!
    respond_to do |format|
      format.html { redirect_to field_visit_activities_url, status: :see_other, notice: "Field visit activity was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_field_visit_activity
    @field_visit_activity = FieldVisitActivity.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @field_visit_activity
  rescue ActiveRecord::RecordNotFound
    redirect_to field_visit_activities_path
  end

  # Only allow a list of trusted parameters through.
  def field_visit_activity_params
    params.require(:field_visit_activity).permit(:name, :description, :field_visit_area_id, :scheduled_date, :duration, :max_participants, :notes)

    # Uncomment to use Pundit permitted attributes
    # params.require(:field_visit_activity).permit(policy(@field_visit_activity).permitted_attributes)
  end
end
