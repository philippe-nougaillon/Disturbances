class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:status]

  def status
    @gares = Source.pluck(:gare).uniq
    @sources = Source.all
  end

  def cancelled
    query = "SELECT DISTINCT date,train FROM Disturbances WHERE perturbation = 'Supprimé' "
    

    unless params[:date].blank?
      query = query + " AND date = '#{ params[:date] }'" 
    end

    if params[:source]
      query = query + " AND source_id IN (#{ current_user.sources.pluck(:id).join(', ') })" 
    end

    @cancelled = Disturbance.find_by_sql(query + ' ORDER BY date DESC')    
    @paginatable_cancelled = Kaminari.paginate_array(@cancelled).page(params[:page]).per(100)

    respond_to do |format|
      format.html

      format.xls do
        book = CancelledToXls.new(@cancelled, (params[:with_payload] == 'true')).call
        file_contents = StringIO.new
        book.write file_contents
        filename = 'suppressions.xls'
        send_data file_contents.string.force_encoding('binary'), filename: filename
      end
    end
  end

  def stats
    @disturbances = Disturbance.all
    @gares = Gare.pluck(:origine)
    @trains = Train.pluck(:train)
    @perturbations = Disturbance.perturbations
    @informations = Info.pluck(:information)

    if params[:source]
      @disturbances = Disturbance.where(source_id: current_user.sources.pluck(:id))
      @gares = current_user.sources.pluck(:gare)
    end

    unless params[:gare].blank?
      @disturbances = @disturbances.where("disturbances.origine = :search OR disturbances.destination = :search OR disturbances.provenance = :search", { search: params[:gare] })
    end

    unless params[:train].blank?
      @disturbances = @disturbances.where("disturbances.train BETWEEN ? AND ?", params[:train].split('-').first, params[:train].split('-').last)
    end

    unless params[:perturbation].blank?
      s = "%#{params[:perturbation]}%"
      @disturbances = @disturbances.where("disturbances.perturbation LIKE ?", s)
    end

    unless params[:information].blank?
      @disturbances = @disturbances.where("disturbances.information = ?", params[:information])
    end

    unless params[:periode].blank?
      @disturbances = @disturbances.where("DATE(disturbances.created_at) BETWEEN ? AND ?", Date.today - params[:periode].to_i.days, Date.today)
    end

    @disturbances = @disturbances
                .group(:date, :train)
                .reorder(nil)
                .count(:id)
                .keys
                .sort
                .map{|key| key.first}
                .tally
  end
end
