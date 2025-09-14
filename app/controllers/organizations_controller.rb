class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy]

  # GET /organizations
  def index
    @pagy, @organizations = pagy(Organization.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @organizations
  end

  # GET /organizations/1 or /organizations/1.json
  def show
  end

  # GET /organizations/new
  def new
    @organization = Organization.new

    # Uncomment to authorize with Pundit
    # authorize @organization
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations or /organizations.json
  def create
    @organization = Organization.new(organization_params)

    # Uncomment to authorize with Pundit
    # authorize @organization

    respond_to do |format|
      if @organization.save
        format.html { redirect_to @organization, notice: "Organization was successfully created." }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

    def create_from_form
    @organization = Organization.new(name: params[:name])

    if @organization.save
      render json: { success: true, id: @organization.id, name: @organization.name }
    else
      render json: { success: false, errors: @organization.errors.full_messages }, status: :unprocessable_entity
    end
  end

  
  # PATCH/PUT /organizations/1 or /organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to @organization, notice: "Organization was successfully updated." }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1 or /organizations/1.json
  def destroy
    @organization.destroy!
    respond_to do |format|
      format.html { redirect_to organizations_url, status: :see_other, notice: "Organization was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_organization
    @organization = Organization.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @organization
  rescue ActiveRecord::RecordNotFound
    redirect_to organizations_path
  end

  # Only allow a list of trusted parameters through.
  def organization_params
    params.require(:organization).permit(:name, :location, :allowed_participant_number)

    # Uncomment to use Pundit permitted attributes
    # params.require(:organization).permit(policy(@organization).permitted_attributes)
  end
end
