class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:status]

  def status
    @sources = Source.order(:gare, :sens)
  end
end
