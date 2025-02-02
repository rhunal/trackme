class CitiesController < ApplicationController
  include Importable

  before_action :set_city, only: [:show, :edit, :update, :destroy]

  # GET /cities
  # GET /cities.json
  def index
    @grid = CitiesGrid.new(grid_params) do |scope|
      scope.page(params[:page])
    end

    @cities = @grid.assets
  end

  # GET /cities/1
  # GET /cities/1.json
  def show
  end

  # GET /cities/new
  def new
    @city = City.new
  end

  # GET /cities/1/edit
  def edit
  end

  # POST /cities
  # POST /cities.json
  def create
    @city = City.new(city_params)

    respond_to do |format|
      if @city.save
        format.html { redirect_to cities_url, notice: 'City was successfully created.' }
        format.json { render :show, status: :created, location: @city }
      else
        format.html { render :new }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cities/1
  # PATCH/PUT /cities/1.json
  def update
    respond_to do |format|
      if @city.update(city_params)
        format.html { redirect_to cities_url, notice: 'City was successfully updated.' }
        format.json { render :show, status: :ok, location: @city }
      else
        format.html { render :edit }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.json
  def destroy
    @city.destroy
    respond_to do |format|
      format.html { redirect_to cities_url, notice: 'City was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    add_breadcrumb "Import #{controller_name.titleize}", instance_variable_get("@#{controller_name.singularize}")
  end

  def import_post
    City.import_csv(
      csv_file_path: params[:import][:file].try(:path),
      country: params[:import][:country]
    )

    flash[:notice] = "Success !!"
    redirect_to send("#{controller_name}_path")
  rescue StandardError => ex
    flash[:alert] = "error: #{ex.message}"
    redirect_to send("import_#{controller_name}_path")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city
      @city = City.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def city_params
      params.require(:city).permit(:name, :country_name)
    end

    def grid_params
      params.fetch(:cities_grid, {}).permit!
    end
end
