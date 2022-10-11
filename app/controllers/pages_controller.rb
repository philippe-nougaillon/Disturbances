class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:status]

  def status
    @gares = Source.pluck(:gare).uniq
    @sources = Source.all
  end

  def cancelled
    @cancelled = Cancelled.all
    @paginatable_cancelled = Kaminari.paginate_array(@cancelled).page(params[:page]).per(25)

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
end
