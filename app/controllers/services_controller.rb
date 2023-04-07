class ServicesController < ApplicationController
  before_action :set_service, only: %i[ show edit update destroy ]
  before_action :is_user_authorized

  # GET /services or /services.json
  def index
    @services = Service.all
    @gares = Gare.pluck(:origine)

    if (!params[:du].blank? && !params[:au].blank?)
      @services = @services.where("DATE(services.date) BETWEEN ? AND ?", params[:du], params[:au])
    end

    unless params[:mode].blank?
      @services = @services.where("services.mode = :search", { search: params[:mode] })
    end

    unless params[:num_service].blank?
      @services = @services.where("services.numéro_service BETWEEN ? AND ?", params[:num_service].split('-').first, params[:num_service].split('-').last)
    end

    unless params[:gare].blank?
      @services = @services.where("services.origine = :search OR services.destination = :search", { search: params[:gare] })
    end

    @services = @services.page(params[:page])
  end

  # GET /services/1 or /services/1.json
  def show
  end

  # GET /services/new
  def new
    @service = Service.new
  end

  # GET /services/1/edit
  def edit
  end

  # POST /services or /services.json
  def create
    @service = Service.new(service_params)

    respond_to do |format|
      if @service.save
        format.html { redirect_to service_url(@service), notice: "Service was successfully created." }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services/1 or /services/1.json
  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to service_url(@service), notice: "Service was successfully updated." }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1 or /services/1.json
  def destroy
    @service.destroy

    respond_to do |format|
      format.html { redirect_to services_url, notice: "Service was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def service_params
      params.require(:service).permit(:date, :train, :horaire, :destination)
    end

    def is_user_authorized
      authorize Service
    end
end
