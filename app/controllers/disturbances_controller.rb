class DisturbancesController < ApplicationController
  before_action :set_disturbance, only: %i[ show edit update destroy ]
  before_action :is_user_authorized

  # GET /disturbances or /disturbances.json
  def index
    @disturbances = Disturbance.all
    @gares = Gare.pluck(:origine)
    @trains = Train.pluck(:train)
    @perturbations = Disturbance.perturbations
    @informations = Info.pluck(:information)
    @filters = current_user.filters

    if params[:source]
      @disturbances = Disturbance.where(source_id: current_user.sources.pluck(:id))
      @gares = current_user.sources.pluck(:gare)
    end

    unless params[:gare].blank?
      @disturbances = @disturbances.where("disturbances.origine = :search OR disturbances.destination = :search OR disturbances.provenance = :search", { search: params[:gare] })
    end

    unless params[:train].blank?
      @disturbances = @disturbances.filter_by_trains(params[:train])
    end

    unless params[:perturbation].blank?
      if params[:perturbation].include?('Retard > ')
        # Filtre les perturbations avec un retard d'au moins x minutes
        @disturbances = @disturbances.where(
          "(regexp_match(disturbances.perturbation, '\\d+'))[1]::int >= ?",
          params[:perturbation][/(\d+)/, 1]&.to_i
        )
      else
        @disturbances = @disturbances.where("disturbances.perturbation LIKE ?", "%#{params[:perturbation]}%")
      end
    end

    unless params[:information].blank?
      @disturbances = @disturbances.where("disturbances.information = ?", params[:information])
    end

    if (!params[:du].blank? && !params[:au].blank?)
      @disturbances = @disturbances.where("DATE(disturbances.created_at) BETWEEN ? AND ?", params[:du], params[:au])
    end

    if params[:filter_id].present?
      filter = Filter.find_by(id: params[:filter_id])
      if filter.user == current_user
        @disturbances = @disturbances.filter_by_trains(filter.trains)
      end
    end

    respond_to do |format|
      format.html do 
        @disturbances = @disturbances.page(params[:page])
      end

      format.xls do
        book = DisturbancesToXls.new(@disturbances.first(20000), (params[:with_payload] == 'true')).call
        file_contents = StringIO.new
        book.write file_contents 
        filename = 'perturbations.xls'
        send_data file_contents.string.force_encoding('binary'), filename: filename 
      end
    end
    
  end

  # GET /disturbances/1 or /disturbances/1.json
  def show
  end

  # GET /disturbances/new
  def new
    @disturbance = Disturbance.new
  end

  # GET /disturbances/1/edit
  def edit
  end

  # POST /disturbances or /disturbances.json
  def create
    @disturbance = Disturbance.new(disturbance_params)

    respond_to do |format|
      if @disturbance.save
        format.html { redirect_to disturbance_url(@disturbance), notice: "Perturbation créée avec succès." }
        format.json { render :show, status: :created, location: @disturbance }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @disturbance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /disturbances/1 or /disturbances/1.json
  def update
    respond_to do |format|
      if @disturbance.update(disturbance_params)
        format.html { redirect_to disturbance_url(@disturbance), notice: "Perturbation modifiée avec succès." }
        format.json { render :show, status: :ok, location: @disturbance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @disturbance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /disturbances/1 or /disturbances/1.json
  def destroy
    @disturbance.destroy

    respond_to do |format|
      format.html { redirect_to disturbances_url, notice: "Perturbation supprimée avec succès." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_disturbance
      @disturbance = Disturbance.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def disturbance_params
      params.require(:disturbance)
            .permit(:origine, :date, :train, :départ, :destination, :voie, :perturbation, :information,
                    :départ_prévu, :départ_réel, :provenance, :arrivée, :arrivée_prévue, :arrivée_réelle)
    end

    def is_user_authorized
      authorize Disturbance
    end
end
