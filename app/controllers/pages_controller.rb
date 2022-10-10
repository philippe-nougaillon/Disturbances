class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:status]

  def status
    @gares = Source.pluck(:gare).uniq
    @sources = Source.all
  end

  def cancelled
    @cancelled = Disturbance.find_by_sql("SELECT DISTINCT date,train FROM Disturbances WHERE perturbation = 'Supprimé' ORDER BY date DESC LIMIT 100")

    respond_to do |format|
      format.html do 
      end

      format.xls do
        book = CancelledToXls.new(@deleted, (params[:with_payload] == 'true')).call
        file_contents = StringIO.new
        book.write file_contents
        filename = 'perturbations.xls'
        send_data file_contents.string.force_encoding('binary'), filename: filename
      end
    end
  end
end
