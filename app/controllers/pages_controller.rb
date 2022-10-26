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
    @cancelled = Disturbance
                .where(perturbation: "Supprimé")
                .group(:date, :train)
                .reorder(nil)
                .count(:id)
                .keys
                .sort
                .map{|key| key.first}
                .tally
    # @cancelled_date = @cancelled.select(:id)pluck(:date).uniq.reorder(:date)
    # @cancelled_count = @cancelled.select(:id).group(:date).reorder(nil).count(:id).values
  end
end
