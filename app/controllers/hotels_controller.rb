class HotelsController < ApplicationController
  before_action :set_hotel, only: [:show, :edit, :update, :destroy]

  # GET /hotels
  def index
    @pagy, @hotels = pagy(Hotel.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @hotels
  end

  # GET /hotels/1 or /hotels/1.json
  def show
  end

  # GET /hotels/new
  def new
    @hotel = Hotel.new

    # Uncomment to authorize with Pundit
    # authorize @hotel
  end

  # GET /hotels/1/edit
  def edit
  end

  # POST /hotels or /hotels.json
  def create
    @hotel = Hotel.new(hotel_params)

    # Uncomment to authorize with Pundit
    # authorize @hotel

    respond_to do |format|
      if @hotel.save
        format.html { redirect_to @hotel, notice: "Hotel was successfully created." }
        format.json { render :show, status: :created, location: @hotel }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @hotel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hotels/1 or /hotels/1.json
  def update
    respond_to do |format|
      if @hotel.update(hotel_params)
        format.html { redirect_to @hotel, notice: "Hotel was successfully updated." }
        format.json { render :show, status: :ok, location: @hotel }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @hotel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hotels/1 or /hotels/1.json
  def destroy
    @hotel.destroy!
    respond_to do |format|
      format.html { redirect_to hotels_url, status: :see_other, notice: "Hotel was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_hotel
    @hotel = Hotel.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @hotel
  rescue ActiveRecord::RecordNotFound
    redirect_to hotels_path
  end

  # # Only allow a list of trusted parameters through.
  # def hotel_params
  #   params.require(:hotel).permit(:name, :location, :room_numbers)

  #   # Uncomment to use Pundit permitted attributes
  #   # params.require(:hotel).permit(policy(@hotel).permitted_attributes)
  # end

    def hotel_params
    params.require(:hotel).permit(:name, :location, :total_rooms, :rooms_available, participant_type_ids: [])
  end
end
