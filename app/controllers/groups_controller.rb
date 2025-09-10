class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  def index
    @pagy, @groups = pagy(Group.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @groups
  end

  # GET /groups/1 or /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new

    # Uncomment to authorize with Pundit
    # authorize @group
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups or /groups.json
  def create
    @group = Group.new(group_params)

    # Uncomment to authorize with Pundit
    # authorize @group

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: "Group was successfully created." }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: "Group was successfully updated." }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    @group.destroy!
    respond_to do |format|
      format.html { redirect_to groups_url, status: :see_other, notice: "Group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @group
  rescue ActiveRecord::RecordNotFound
    redirect_to groups_path
  end

  # Only allow a list of trusted parameters through.
  def group_params
    params.require(:group).permit(:name, :description)

    # Uncomment to use Pundit permitted attributes
    # params.require(:group).permit(policy(@group).permitted_attributes)
  end
end
